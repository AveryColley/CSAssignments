// CEG 4750 - Information Security
// Avery Colley
// Meilin Lu
// 4/9/2025
// Project 1 AES CBC Decryption

#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
using namespace std;

#include"cryptopp/cryptlib.h"
#include"cryptopp/hex.h"
#include"cryptopp/filters.h"
#include"cryptopp/des.h"
#include"cryptopp/aes.h"
#include"cryptopp/modes.h"

using namespace CryptoPP;

string aes_decode(string & cipher,byte key[], byte iv[])
{
	string plain;
	try{
		CBC_Mode< AES >::Decryption dec;
		dec.SetKeyWithIV(key, AES::DEFAULT_KEYLENGTH, iv);
		StringSource s(cipher, true, new StreamTransformationFilter(dec, new StringSink(plain)));
		//add padding by SteamTransformationFilter
	}
	catch(const CryptoPP::Exception& e){
	}
	return plain;
}
int main(int argc,char * argv[])
{
	fstream file1;
	fstream file2;
	byte key[AES::DEFAULT_KEYLENGTH];
	byte iv[16];

	for(int i = 0; i < 16; i++) {
		iv[i] = (byte)i;
	}

	if(argc!=4)
	{
		cout<<"usage:aes_decode infile outfile key"<<endl;
		return 0;
	}
	file1.open(argv[1],ios::in);
	file2.open(argv[2],ios::out);
	//reading
	stringstream buffer;
	buffer << file1.rdbuf();
	string cipher(buffer.str());
	//get key
	memset(key,0,AES::DEFAULT_KEYLENGTH);
	for(int i=0;i<AES::DEFAULT_KEYLENGTH;i++)
	{
		if(argv[3][i]!='\0')
		{
			key[i]=(byte)argv[3][i];
		}
		else
		{
			break;
		}
	}
	//print key
	string encoded;
	encoded.clear();
	StringSource(key, sizeof(key), true, new HexEncoder( new StringSink(encoded)));
	cout << "key: " << encoded<< endl;
	//decode
	string plain=aes_decode(cipher,key,iv);
	cout << "recovered text: " << plain<< endl;
	file2<<plain;
	cout<<"plain text stored in:"<<argv[2]<<endl;
}
