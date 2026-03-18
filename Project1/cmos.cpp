/**
 * @file cmos.cpp
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief main application that performs similarity calculations from lexical analysis
 * @date 2026-03-16
 * 
 */

//libraries 
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iomanip>

using namespace std;

struct Program {
    string name;
    string tokens;
    vector<int> fingerprints;
};

struct Result {
    string a;
    string b;
    double score;
};

/* ---------- Remove spaces between tokens ---------- */

string cleanTokens(const string &line) {
    string cleaned;
    for(char c : line) {
        if(c != ' '){
            cleaned += c;
        }
    }
    return cleaned;
}

/* ---------- Create overlapping k-mers ---------- */

vector<string> addkmers(const string &tokens, int k) {
    vector<string> kmers;
    for(size_t i = 0; i <= tokens.length() - k; i++) {
        kmers.push_back(tokens.substr(i,k));
    }
    return kmers;
}

/* ---------- Simple numeric hash ---------- */

int hashkmer(const string &kmer){
    int hashing = 0;
    for(size_t i = 0; i < kmer.length(); ++i){
        char a = kmer[i];
        hashing = hashing * 10 + (a - '0');
    }
    return hashing;
}

/* ---------- Hash all kmers ---------- */

vector<int> allkmers(const vector<string> &allkmers){
    vector<int> hashes;
    for(size_t i = 0; i < allkmers.size(); i++){
        hashes.push_back(hashkmer(allkmers[i]));
    }
    return hashes;
}

/* ---------- Winnowing window fingerprints ---------- */

vector<int> fingerprints(const vector<int> &hashes, int w){
    vector<int> fingerprints;
    for(size_t i = 0; i < hashes.size() - w; ++i){
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

/* ---------- Similarity score ---------- */

double similarity(const vector<int> &A, const vector<int> &B) {
    int shared = 0;
    for(size_t a = 0; a < A.size(); ++a) {
        for(size_t b = 0; b < B.size(); ++b) {
            if(A[a] == B[b]) {
                shared++;
                break;
            }
        }
    }
    int total = A.size() + B.size() - shared;
    return (double)shared / total;
}

/* ---------- MAIN ---------- */

int main() {
    const int K = 9;   // k-mer size
    const int W = 5;   // window size

    vector<Program> programs;
    ifstream in("tokens.txt");

    string filename;
    string rest;

    while(in >> filename) {
        getline(in, rest);

        Program p;

        p.name = filename;
        p.tokens = cleanTokens(rest);

        vector<string> k = addkmers(p.tokens, K);
        vector<int> h = allkmers(k);

        p.fingerprints = fingerprints(h, W);
        programs.push_back(p);
    }

    /* ---------- Compare all submissions ---------- */

    vector<Result> results;

    for(size_t i = 0; i < programs.size(); i++) {
        for(size_t j = i+1; j < programs.size(); j++) {
            double s = similarity(programs[i].fingerprints, programs[j].fingerprints);

            results.push_back({
                    programs[i].name,
                    programs[j].name,
                    s
            });
        }
    }

    /* ---------- Sort by highest similarity ---------- */

    sort(results.begin(), results.end(),
        [](const Result &a, const Result &b) {
            return a.score > b.score;
        });

    /* ---------- Output report ---------- */

    cout << "C-Program Similarity Ranking\n\n";
    cout << "Match %\tFile A\t\tFile B\n";

    for (size_t i = 0; i < results.size(); ++i) {
        cout << fixed << setprecision(2)
            << (results[i].score)*100 << "%\t"
            << results[i].a << "\t"
            << results[i].b << endl;
    }

    return 0;
}