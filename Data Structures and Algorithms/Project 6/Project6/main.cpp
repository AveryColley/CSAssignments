#include "Database.cpp"

using namespace std;

int main() {
   Database myDatabase;
   string response;
   while(true) {
      cout << "Would you like to (I)nsert or (D)elete a record, (S)earch for a record, (P)rint the database, or (Q)uit?\n";
      cout << "Enter action: ";
      getline(cin, response);

      if(response == "Q" || response == "q") { // Quitting
         cout << "Exiting\n";
         break;

      } else if(response == "P" || response == "p") { // Printing
         cout << myDatabase;

      } else if(response == "I" || response == "i") { // Inserting
         cout << "Inserting a new record\n";
         string lastName;
         string firstName;
         int uid;
         string year;
         int collisions;

         cout << "Last name: ";
         cin >> lastName;
         cout << "First name: ";
         cin >> firstName;
         cout << "UID: ";
         cin >> uid;
         cout << "Year: ";
         cin >> year;

         Record newRecord = Record(firstName, lastName, uid, year);  // Creating new Record
         if(myDatabase.insert(newRecord, collisions)) {  // Attemping to insert new Record
            cout << "Record inserted (" << collisions << " collisions during insert).\n";
         } else {
            cout << "Could not insert record\n";
         }

      } else if(response == "D" || response == "d") { // Deleting
         int toDelete;
         cout << "Enter a UID to delete: ";
         cin >> toDelete;
         cout << "Deleting record... ";
         if(myDatabase.remove(toDelete)) {
            cout << " deletion successful\n";
         } else {
            cout << " couldn't find record to delete\n";
         }

      } else if(response == "S" || response == "s") { // Searching
         int searchTerm;
         Record newRecord;
         int collisions;
         cout << "Enter UID to search for: ";
         cin >> searchTerm;
         cout << "Searching... ";
         if(myDatabase.find(searchTerm, newRecord, collisions)) {
            cout << "record found (" << collisions << " collisions during search)\n";
            cout << "----------------------------\n";
            cout << "Name: " << newRecord.getName() << "\n";
            cout << "UID: " << newRecord.getUID() << "\n";
            cout << "Year: " << newRecord.getYear() << "\n";
            cout << "----------------------------\n";
         } else {
            cout << "record not found\n";
         }
      }
   }
}