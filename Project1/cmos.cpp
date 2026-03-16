/**
 * @file cmos.cpp
 * @author Matthew and Nicolas 
 * @brief 
 * @date 2026-03-16
 * 
 */

//libraries 
#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;


string read(const string &file ){
    string token;
    string tokenizedstring;

    ifstream ins(file);

    while(ins >> token){
        tokenizedstring += token;
    }
    ins.close();
    return tokenizedstring;
    
}


vector<string> addkmers(const string &tokens, int k){
    vector<string> kmers;
    for(size_t i = 0; i <= tokens.length(); i++){
        kmers.emplace_back(tokens.substr(i,k));
    }
    return kmers;
}


int hashkmer(const string &kmer){
    int hashing = 0;
    for(size_t i = 0; i < kmer.length(); ++i){
        char a = kmer[i];
        hashing = hashing * 10 + (a - '0');
    }
    return hashing;
}




vector<int> allkmers(const vector<string> &allkmers){
    vector<int> hashes;
    for(size_t i = 0; i < allkmers.size(); i++){
        hashes.push_back(hashkmer(allkmers[i]));
    }
    return hashes;
}


vector<int> fingerprints(const vector<int> &hashes, int w){
    vector<int> fingerprints;
    for(size_t i = 0; i < hashes.size(); ++i){
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

int main(){

//test

int w = 4;
int k = 5;

string tokens = read("tokens.txt");
vector<string> kmers =  addkmers(tokens, k);
vector<int> hashes = allkmers(kmers);
vector<int> print = fingerprints(hashes, w);

for(size_t i = 0; i < print.size(); ++i){
    cout << print[i] << endl;
}

}




