/*
   Implements a Database using a HashTable and vector of Records
   Avery Colley
*/

#include "Database.h"

using namespace std;

// Constructor: Initializes the HashTable and recordStore to be empty
Database::Database() {
   indexTable = HashTable();
   vector<Record> recordStore;
}

// Insert: Inserts a new student record into the Database, returns true and the number of collisions if successfully inserted
//         Returns false otherwise
bool Database::insert(const Record& newRecord, int& collisions) {
   int index = recordStore.size();  // Index for the record
   if(indexTable.find(newRecord.getUID(), index, collisions) || indexTable.alpha() == 1) {   // Duplicate key or full HashTable
      return false;
   } else {
      indexTable.insert(newRecord.getUID(), index, collisions);   // Inserting into HashTable
      recordStore.push_back(newRecord);   // Inserting into recordStore
      return true;
   }
}

// Remove: removes the record with the given key from the Database. Returns true if successfully removec and false otherwise
bool Database::remove(int key) {
   int index;
   int collisions;
   if(indexTable.find(key, index, collisions)) {
      indexTable.remove(key); // Deleting record
      recordStore[index] = recordStore.back();
      recordStore.pop_back();
      indexTable.setIndex(key, index); // Fixing index
      return true;
   }
   return false;
}

// Find: Finds a given record in the Database and returns true along with the found record if the record is successfully found
//       Returns false if the record is not found
bool Database::find(int uid, Record& foundRecord, int& collisions) {
   int index;
   if(indexTable.find(uid, index, collisions)) {
      foundRecord = recordStore[index];
      return true;
   }
   return false;
}

// Alpha: Returns the load factor of the Database
float Database::alpha() {
   return indexTable.alpha();
}

// Operator<<: Prints out the Database in the following format:
//             Database contents:
//             recordStore slot # -- lastName, firstName (UID): Year
//             recordStore slot # -- lastName, firstName (UID): Year
//             etc.
ostream& operator<<(ostream& os, const Database& database) {
   os << "Database contents:\n";
   for(int i = 0; i < database.recordStore.size(); i++) {
      os << "recordStore slot " << i << " -- " << database.recordStore[i].getName() << " (U" <<
      database.recordStore[i].getUID() << "): " << database.recordStore[i].getYear() << "\n";
   }
   return os;
}

// Destructor: Deletes the Database
Database::~Database() {
   recordStore.clear();
}
