/*
   Jacob Colley
   Header file for the Character class
*/

#include <string>

using namespace std;

class Character{
   private:

   string name;
   string role;
   int hp;
   int attackBonus;
   int damageBonus;
   int ac;

   public:

   //Constructors
   Character();
   Character(string, string, int, int, int, int);

   //Getters
   int getHealth();
   string getName();
   string getRole();
   int getAttackBonus();
   int getDamageBonus();
   int getAC();

   //Other Methods
   void print(ostream&);
   int* attack(Character&);
   void damage(int);
};