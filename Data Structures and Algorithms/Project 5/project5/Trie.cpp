/*
   Trie.cpp file - implements an alphabet Trie that only accepts lowercase letters
   Jacob Colley
*/

#include "Trie.h"

// Constructor: Creates a new Trie, with an empty root, 1 node and 0 words
Trie::Trie() {
   root = new TrieNode();
   nodeCount = 1;
   wordCount = 0;
}

// Destructor: Deletes the Trie
Trie::~Trie() {
   clear(root);
}

// Copy Constructor: Creates an independant copy of the Trie
Trie::Trie(const Trie &t) {
   *this = t;
}

// insertHelp: Recursive helper fuction for insert. Inserts a new word into the Trie letter by letter.
//             If the word is already in the Trie, returns false. Otherwise returns true
bool Trie::insertHelp(string s, TrieNode* &current, int index) {
   if(s[index] - 'a' < 0 || s[index] - 'a' > 25) { // Checking to see if end of word
      if(current->nodes[26] == nullptr) {
         current->nodes[26] = new TrieNode();
         nodeCount++; // Update nodeCount
         return true;
      } else {
         return false;
      }
   }

   if(current->nodes[s[index] - 'a'] == nullptr) {
      current->nodes[s[index] - 'a'] = new TrieNode();
      nodeCount++; // Update NodeCount
   }

   return insertHelp(s, current->nodes[s[index] - 'a'], index + 1);
}

// insert: Inserts a given word into the Trie. Returns true if the word was successfully inserted and false otherwise.
//         Duplicates are not allowed in the Trie
bool Trie::insert(string s) {
   if(s.empty()) { // Checking empty string
      return false;
   }

   return insertHelp(s, root, 0);
}

// count: Returns the amount of words in the Trie
int Trie::count() {
   countHelp(root);
   int i = wordCount;
   wordCount = 0; // Resetting wordCount
   return i;
}

// getSize: Returns the total amount of Nodes in the Trie
int Trie::getSize() {
   return nodeCount;
}

// findHelp: Recursive helper function for find. Takes a given string and returns true if the string is both
//           a complete word AND in the Trie. And false otherwise
bool Trie::findHelp(string s, TrieNode* current, int index) {
   if(s[index] - 'a' < 0 || s[index] - 'a' > 25) { // Word must be complete
      if(current->nodes[26] == nullptr) {
         return false;
      } else {
         return true;
      }
   }

   if(current->nodes[s[index] - 'a'] == nullptr) { // Letter of word not found, word not in Trie
      return false;
   }

   return findHelp(s, current->nodes[s[index] - 'a'], index + 1);
}

// find: Returns true if the given string is found in the Trie, false otherwise. Given word MUST constain an end of word character
bool Trie::find(string s) {
   if(s.empty()) { // Checking empty string
      return false;
   }

   return findHelp(s, root, 0);
}

// countHelp: Recursive helper function for count. Given a TrieNode, increments wordCount for every complete word found "below" the node
void Trie::countHelp(TrieNode* current) {
   for(int i = 0; i < 27; i++) {
      if(current->nodes[i] != nullptr && i == 26) {
         wordCount++; // Word found
         return;
      } else if(current->nodes[i] != nullptr) {
         countHelp(current->nodes[i]);
      }
   }

   return;
}

// completeCountHelp: Recursive helper function for completeCount. Given a string, returns the amount of words that start with the given string
void Trie::completeCountHelp(string s, TrieNode* current, int index) {
   if(index + 1 > s.size()) {
      countHelp(current); // Using count help at the "end" of the string
      return;
   }

   if(current->nodes[s[index] - 'a'] == nullptr) { // Part of the string isn't found
      return;
   }

   completeCountHelp(s, current->nodes[s[index] - 'a'], index + 1);
   return;
}

// completeCount: Returns the amount of words in the Trie that start with the given string
int Trie::completeCount(string s) {
   if(find(s)) { // The string given is a full word and in the Trie
      return 1;
   }

   completeCountHelp(s, root, 0);
   int i = wordCount;
   wordCount = 0; // Resetting wordCount
   return i;
}

// completeHelp: Recursive helper function for complete. adds words that being with the provided string into a vector of strings
void Trie::completeHelp(vector<string> &v, TrieNode* current, string s) {
   for(int i = 0; i < 27; i++) {
      if(current->nodes[i] != nullptr && i == 26) { // Word is in the Trie
         v.push_back(s); // Add string to vector
         return;
      } else if(current->nodes[i] != nullptr) {
         completeHelp(v, current->nodes[i], s += (char) ('a' + i));
      }
   }
}

// complete: Returns a vector of strings that start with the given string and are also in the Trie
vector<string> Trie::complete(string s) {
   vector<string> v = {};

   if(s.empty()) { // Checking empty string
      return v;
   }

   // Reaching the node at the end of the string
   TrieNode* endOfString = root;
   for(int i = 0; i < s.size(); i++) {
      if(endOfString == nullptr) { // If the Node is null, the string isn't in the Trie
         return v;
      }
      endOfString = endOfString->nodes[s[i] - 'a'];
   }

   completeHelp(v, endOfString, s);
   return v;
}

// clear: Clears out the Trie, deleting all of the TrieNodes below the given TrieNode: Deletes the root as well
void Trie::clear(TrieNode* current) {
   for(int i = 0; i < 27; i++) {
      if(current->nodes[i] != nullptr) {
         clear(current->nodes[i]);
      }
   }
   nodeCount = 0;
   delete current; // Already deleted all the children
   return;
}

// equalsHelper: Recursive helper function for equals, sets this Trie to be equal but independant of the given Trie
void Trie::equalsHelper(const Trie& t, TrieNode* current, TrieNode* tCurrent) {
   for(int i = 0; i < 27; i++) {
      if(tCurrent->nodes[i] != nullptr) { // Node exists in given Trie, so must make a new one in This Trie
         current->nodes[i] = new TrieNode();
         nodeCount++;
         equalsHelper(t, current->nodes[i], tCurrent->nodes[i]);
      }
   }
   return;
}

// operator=: Clears out this Trie and makes an independant copy  of the provided Trie
Trie& Trie::operator=(const Trie& t) {
   clear(root);
   root = new TrieNode();
   nodeCount = 1;
   equalsHelper(t, root, t.root);
   return *this;
}