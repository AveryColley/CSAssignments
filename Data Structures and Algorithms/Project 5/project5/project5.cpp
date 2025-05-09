/*
   Jacob Colley
   Project #5 - Building a word autocomplete application using an alphabet trie

   Main file for prompting user for a word prefix and then giving them the completions of that prefix
*/


#include "Trie.cpp"
#include <iostream>
#include <fstream>

using namespace std;

int main() {
   Trie t1 = Trie();

   string currentLine;
   ifstream wordList("wordlist_windows.txt");
   while(getline(wordList, currentLine)) {
      t1.insert(currentLine);
   }

   string response;
   while(true) {
      cout << "Please enter a word prefix (or press enter to exit): ";
      getline(cin, response);
      if(response == "") { // Checks for empty line
         break;
      }
      string prefix = response;
      cout << "There are " << t1.completeCount(prefix) << " completions for the prefix '" << response << "'. Show completions? ";
      getline(cin, response);
      if(response[0] == 'y' || response[0] == 'Y') { // Checks for yes/yeah/ye/Ya/Yea/etc.
         vector<string> v = t1.complete(prefix);
         cout << "Completions" << "\n";
         cout << "-----------" << "\n";
         for(int i = 0; i < v.size(); i++) {
            cout << v[i] << "\n";
         }
      }
   }
}