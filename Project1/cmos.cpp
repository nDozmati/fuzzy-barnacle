/**
 * @file cmos.cpp
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief main application that performs similarity calculations from lexical analysis
 * @date 2026-03-16
 * 
 */

// libraries for I/O, strings, containers, algorithms, and formatting
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iomanip>

using namespace std;

/* DATA STRUCTURES */

// single program submission
struct Program {
    string name;                  // filename of the program
    string tokens;                // cleaned token string (no spaces)
    vector<int> fingerprints;     // winnowed fingerprint hashes
};

// similarity result between two programs
struct Result {
    string a;     // program A name
    string b;     // program B name
    double score; // similarity score (0–1)
};

// helper: removes spaces between tokens for proper k-mer generation across token boundaries (one long string)
string cleanTokens(const string &line) {
    string cleaned;
    for(char c : line) {
        if(c != ' '){
            cleaned += c;
        }
    }
    return cleaned;
}


/* OVERLAPPING K-MERS */

// generate all substrings of length k from the token string
vector<string> addkmers(const string &tokens, int k) {
    vector<string> kmers;
    for(size_t i = 0; i <= tokens.length() - k; i++) {
        kmers.push_back(tokens.substr(i,k));
    }
    return kmers;
}

// converts a number string k-,er into an integer value
int hashkmer(const string &kmer){
    int hashing = 0;
    for(size_t i = 0; i < kmer.length(); ++i){
        char a = kmer[i];
        hashing = hashing * 10 + (a - '0');
    }
    return hashing;
}

// applies hashkmer to every k-mer
vector<int> allkmers(const vector<string> &allkmers){
    vector<int> hashes;
    for(size_t i = 0; i < allkmers.size(); i++){
        hashes.push_back(hashkmer(allkmers[i]));
    }
    return hashes;
}


/* WINNOWING WINDOW FINGERPRINTS */

// sliding window of size w over hashes
// selects the minimum hash in each window
// produces a reduced set of representative fingerprints
vector<int> fingerprints(const vector<int> &hashes, int w){
    vector<int> fingerprints;
    for(size_t i = 0; i <= hashes.size() - w; ++i){
        int smallest = hashes[i];
        for (int j = 0; j < w; j++){
            if(hashes[i+j] < smallest){
                smallest = hashes[i+j];
            }
        }
        fingerprints.emplace_back(smallest);
    }
    return fingerprints;
}

/* SIMILARITY SCORING (Jaccard) */
// Computes similarity using intersection / union
// intersection = shared fingerprints
// union = total unique elements approximation
double similarity(const vector<int> &A, const vector<int> &B) {
    int shared = 0;
    // count shared fingerprints
    for(size_t a = 0; a < A.size(); ++a) {
        for(size_t b = 0; b < B.size(); ++b) {
            if(A[a] == B[b]) {
                shared++;
                break; // avoid double counting
            }
        }
    }
    int total = A.size() + B.size() - shared;
    return (double)shared / total;
}


/* MAIN: PLAGIARISM DETECTOR */

int main() {
    const int K = 9;   // k-mer size (controls granularity: group size)
    const int W = 5;   // window size (controls fingerprint density: group clustering)

    vector<Program> programs;
    ifstream in("tokens.txt");

    string filename;
    string rest;

    // read tokenized programs from file
    while(in >> filename) {
        getline(in, rest);  // rest of line = token sequence

        Program p;

        p.name = filename;
        p.tokens = cleanTokens(rest);  // remove spaces

        // generate k-mers -> hash -> fingerprints
        vector<string> k = addkmers(p.tokens, K);
        vector<int> h = allkmers(k);
        p.fingerprints = fingerprints(h, W);

        programs.push_back(p);
    }

    // compare all submissions
    vector<Result> results;

    // compare every pair of programs
    for(size_t i = 0; i < programs.size(); i++) {
        for(size_t j = i+1; j < programs.size(); j++) {
            double s = similarity(programs[i].fingerprints,
                                  programs[j].fingerprints);

            results.push_back({
                programs[i].name,
                programs[j].name,
                s
            });
        }
    }

    // plagiarism report output
    cout << "C-Program Similarity Ranking\n\n";
    
    // rank files by plagiarism likelyhood
    vector<pair<string, double>> suspicion;
    // for each program i and j, find the maximum similarity
    for (size_t i = 0; i < programs.size(); ++i) {
        double maxScore = 0.0;
        for (size_t j = 0; j < results.size(); ++j) {
            // check if this file is involved in the pair
            if (results[j].a == programs[i].name ||
                results[j].b == programs[i].name) {
                if (results[j].score > maxScore) {
                    maxScore = results[j].score;
                }
            }
        }
        suspicion.push_back({programs[i].name, maxScore});
    }

    // sort by suspicion value
    sort(suspicion.begin(), suspicion.end(),
        [](const pair<string,double> &a, const pair<string,double> &b) {
            if (a.second == b.second) {
                return a.first < b.first; // tie-break by filename
            }
            return a.second > b.second;
        });

    // plagiarism suspicion rankings
    cout << "\nMost Suspicious Files (Ranked)\n";
    cout << "Rank |    File    | Max Similarity\n";
    cout << "-----|------------|---------------\n";
    for (size_t i = 0; i < suspicion.size(); ++i) {
        cout << i+1 << "\t  "
            << suspicion[i].first << "   "
            << fixed << setprecision(2)
            << suspicion[i].second*100 << "%\n";
    }

    // sort pairings by similarity score (1 to 0)
    sort(results.begin(), results.end(),
        [](const Result &a, const Result &b) {
            if (a.score == b.score){
                return a.score < b.score;
            }
            return a.score > b.score;
        });
    
    // derived similarity pairings
    cout << "\nSimilarity Pairings (ordered)\n";
    cout << "Match %|  File A  |  File B  \n";
    cout << "-------|----------|----------\n";
    // print sorted results with percentage formatting
    for (size_t i = 0; i < results.size(); ++i) {
        cout << fixed << setprecision(2)
            << (results[i].score)*100 << "%\t"
            << results[i].a << " "
            << results[i].b << endl;
    }
    cout << "-------|----------|----------\n";
    cout << ">\tEND OF REPORT\n";

    return 0;
}