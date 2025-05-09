/*
   Database.h file for the Database class
   Avery Colley
*/

#include "Record.h"
#include "HashTable.cpp"
#include <vector>

using namespace std;

class Database {
   private:

   HashTable indexTable;
   vector<Record> recordStore;

   public:

   // Constructor:
   Database();

   // Destructor
   ~Database();

   // Manipulating records
   bool insert(const Record&, int&);
   bool remove(int);
   bool find(int, Record&, int&);

   // Gives Database load factor
   float alpha();

   // << overload
   friend ostream& operator<<(ostream&, const Database&);
};
