/*
   HashTable.h file for the HashTable class
   Avery Colley
*/

#include "slot.h"
#include "shuffle.cpp"

#define MAXHASH 20   // Size of the HashTable

class HashTable {
   private:

   Slot table [MAXHASH];   // The actual table
   int items;              // Total amoutn of items in the HashTable
   array<unsigned int, MAXHASH - 1> probeArray; // The Array for Pseudo-random Probing


   public:

   // Empty Constructor
   HashTable();

   // Destructor
   ~HashTable();

   // Finding and manipulating keys
   bool insert(int, int, int&);
   bool remove(int);
   bool find(int , int&, int&);

   // Load factor of HashTable
   float alpha();

   // Sets index of a Slot
   void setIndex(int, int);

   // << Overload
   friend ostream& operator<<(ostream&, const HashTable&);
};
