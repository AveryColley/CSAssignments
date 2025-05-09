/*
   Trie.h file for the Trie class
   Jacob Colley
*/

#include <string>
#include <vector>

using namespace std;

class Trie {
   private:

   // TrieNode class for storing words in the Trie
   class TrieNode {
      public:

      TrieNode* nodes[27]; // One for each lowercase letter and a slot for an end-of-string value

      // Empty constructor, assigns all pointers to null
      TrieNode() {
         for(int i = 0; i < 27; i++) {
            nodes[i] = nullptr;
         }
      }
      // Destructor
      ~TrieNode() {}
   };

   TrieNode* root;   // Top of the Trie
   int nodeCount;    // How many TrieNodes are in the Trie
   int wordCount;    // Total amount of words in the Trie

   // Clears out the Trie
   void clear(TrieNode*);

   // Recursive helper functions
   void equalsHelper(const Trie&, TrieNode*, TrieNode*);
   bool insertHelp(string, TrieNode*&, int);
   bool findHelp(string, TrieNode*, int);
   void countHelp(TrieNode*);
   void completeCountHelp(string, TrieNode*, int);
   void completeHelp(vector<string>&, TrieNode*, string);

   public:

   // Empty constructor
   Trie();

   // Destructor
   ~Trie();

   // Copy constructor
   Trie(const Trie&);

   // Inserts a string
   bool insert(string);

   // Getters
   int count();
   int getSize();

   // Finds a given string
   bool find(string);

   // Gives the amount of words that start with the given string
   int completeCount(string);

   // Returns all the words that start with the given string
   vector<string> complete(string);

   // = overload
   Trie& operator=(const Trie&);
};