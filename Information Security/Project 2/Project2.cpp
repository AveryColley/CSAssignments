// CEG 4750 - Information Security
// Avery Colley
// Meilin Lu
// 4/9/2025
// Project 2 HMAC

#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
using namespace std;

#include"cryptopp/hex.h"
#include"cryptopp/filters.h"
#include"cryptopp/hmac.h"
#include"cryptopp/sha.h"
using namespace CryptoPP;

string hmac_calc(string& plain, byte key[]) {
	string final;
	try{
		HMAC<SHA512> hmac(key, 16);
		StringSource(plain, true, new HashFilter(hmac, new StringSink(final)));
	} catch (const CryptoPP::Exception& e) {
	}
	return final;
}

int main(int argc, char* argv[]) {
	fstream ifile;
	fstream ofile;
	byte key[16];

	// check for 3 arguments
	if(argc != 4) {
		cout << "Not enough arguments" << endl;
		return 0;
	}

	ifile.open(argv[1], ios::in);
	ofile.open(argv[2], ios::out);

	// getting input file
	stringstream buffer;
	buffer << ifile.rdbuf();
	string input(buffer.str());
	// cout << "input: " << input << endl;

	// getting key
	memset(key, 0, 16);
	for(int i = 0; i < 16; i++) {
		if(argv[3][i] != '\0') {
			key[i] = (byte) argv[3][i];
		} else {
			break;
		}
	}

	// calculate hmac
	string hashed = hmac_calc(input, key);

	// store hmac
	ofile << hashed;

	string encoded;
	encoded.clear();
	StringSource(hashed, true, new HexEncoder( new StringSink(encoded)));
	// print hmac
	cout << "HMAC: " << encoded << endl;
	cout << "HMAC stored in: " << argv[2] << endl;

	ifile.close();
	ofile.close();
	return 1;
}