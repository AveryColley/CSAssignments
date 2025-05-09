/*
   Implements a closed HashTable of size MAXHASH that using pseduo-random probing in the case of collisions
   Jacob Colley
*/

#include "HashTable.h"
#include "hashfunction.cpp"

using namespace std;

// Constructor: Initializes all of the Hashtable to empty slots, items to 0, and creates the probing array
HashTable::HashTable() {
   probeArray = makeShuffledArray();
   for(int i = 0; i < MAXHASH; i++) {
      table[i] = Slot();
   }
   items = 0;
}

// Find: Takes a given key and returns true if the key is found in the HashTable, along with the index and number of collisions
//       Returns false otherwise
bool HashTable::find(int key, int& index, int& collisions) {
   int testSpot = jsHash(key) % MAXHASH;  // Hashing the key
   for(int i = 0; i < MAXHASH; i++) {
      if(table[testSpot].isEmptySinceStart()) { // Empty slot
         return false;
      }

      if(table[testSpot].getKey() == key && table[testSpot].isNormal()) {  // Key found and Slot not empty
         collisions = i;                     // Setting collisions
         index = table[testSpot].getIndex(); // Setting index
         return true;
      }

      testSpot = (testSpot + probeArray[i]) % MAXHASH;   // Probing
   }

   return false;
}

// Insert: Given a <key, index> pair will attempt to insert it into a Slot in the HashTable
//         Returns true along with the number of collisions if the key was successfully inserted
//         Returns false otherwise
bool HashTable::insert(int key, int index, int& collisions) {
   if(find(key, index, collisions) || items == MAXHASH) {
      return false;  // Duplicates are not allowed
   }
   collisions = 0;

   int tryPosition = jsHash(key) % MAXHASH;  // Hashing the key
   for(int i = 0; i < MAXHASH; i++) {
      if(table[tryPosition].isEmpty()) {  // Empty Slot found
         table[tryPosition] = Slot(key, index);
         items++; // Updating items
         collisions = i;   // Setting collisions
         return true;
      }
      tryPosition = (tryPosition + probeArray[i]) % MAXHASH;   // Probing
   }

   return false;
}

// Alpha: Returns the load factor of the HashTable, which is equal to the number of items in the HashTable divided by MAXHASH
float HashTable::alpha() {
   return ((float) items / (float) MAXHASH);
}

// Remove: Given a key will attempt to remove that Slot from the HashTable
//         Returns true if the key was successfully removed, and false otherwise
bool HashTable::remove(int key) {
   int index;
   int collisions;
   if(find(key, index, collisions)) {  // Key found
      int killSlot = (jsHash(key) % MAXHASH); // Hashing the key
      for(int i = 0; i < collisions; i++) {
         killSlot = (killSlot + probeArray[i]) % MAXHASH;   // Probing
      }

      table[killSlot].kill(); // Key gets deleted
      items--; // Updating Items
      return true;
   } else {
      return false;
   }
}

// SetIndex: Sets the index of the Slot with the given key to a new value
void HashTable::setIndex(int key, int newIndex) {
   int testSpot = jsHash(key) % MAXHASH;  // Hashing the key
   for(int i = 0; i < MAXHASH; i++) {
      if(table[testSpot].getKey() == key && table[testSpot].isNormal()) {  // Key found and Slot not empty
         table[testSpot].setIndex(newIndex); // Setting index
      }
      testSpot = (testSpot + probeArray[i]) % MAXHASH;   // Probing
   }
}

// Operator<<: Overload for the << operator. Will print the HashTable in the format:
//             HashTable Slot #: Key = ####, Index = ##
//             HashTable Slot #, Key = ####, Index = ##
//             etc.
ostream& operator<<(ostream& os, const HashTable& hashtable) {
   os << "HashTable contents:\n";
   for(int i = 0; i < MAXHASH; i++) {
      if(hashtable.table[i].isNormal()) {
         os << "HashTable Slot " << i << ": Key = " << hashtable.table[i].getKey() << ", Index = " << hashtable.table[i].getIndex() << "\n";
      }
   }
   return os;
}

// Destructor: No destructor is needed as HashTables don't use any dynamically allocated memory
HashTable::~HashTable() {
}