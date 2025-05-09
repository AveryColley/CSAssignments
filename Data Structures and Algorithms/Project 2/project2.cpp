/*
   Jacob Colley
   Project #2 - FIGHT!
   This program allows the user to input statistics for 2 characters in a very simplified RPG format
   and then simulates combat between the 2 characters until one of them wins.
*/

#include "Character.cpp"
#include <time.h>

/*
   getInt: Continually asks the user to input an integer until they do so

   Returns:
      int - The valid integer the user typed, MUST BE >= 0
*/
int getInt() {
   bool valid = false;
   string input;
   while(!valid) {
      cin >> input;
      //Checks the string 1 character at a time to see if they're all integers
      for(int i = 0; i < input.size(); i++) {
         if(!isdigit(input[i])) {
            valid = false;
            cout << "Please enter a valid integer: ";
            break;
         } else {
            valid = true;
         }
      }
   }
   //converts string to int
   int final = stoi(input);
   return final;
}

/*
   createCharacter: Asks the user for inputs to create a character, the final 4 values must be integers

   Return:
      Character - The character that the user created
*/
Character createCharacter() {
   string name;
   string role;
   int hp;
   int attackBonus;
   int damageBonus;
   int ac;
   cout << "Character name?\n";
   cin >> name;
   cout << name << "'s role?\n";
   cin >> role;
   cout << name << " the " << role << "'s hit points?\n";
   hp = getInt();
   cout << name << " the " << role << "'s attack bonus?\n";
   attackBonus = getInt();
   cout << name << " the " << role << "'s damage bonus?\n";
   damageBonus = getInt();
   cout << name << " the " << role << "'s armor class?\n";
   ac = getInt();
   //Creating the character with the given inputs and printing it out
   Character player(name, role, hp, attackBonus, damageBonus, ac);
   player.print(cout);
   return player;
}

/*
   doTurn: Simulates a battle turn where c1 attacks c2

   Parameters:
      &c1 (Character) - The character who is attacking
      &c2 (Character) - The character who is being attacked
*/
void doTurn(Character &c1, Character &c2) {
   cout << "\n" << c1.getName() << " attacks!\n";
   string hitOrMiss;
   int * results;
   int attackRoll;
   int damageRoll;
   results = c1.attack(c2);
   //Getting the actual rolls from the results
   attackRoll = results[0] - c1.getAttackBonus();
   damageRoll = results[1] - c1.getDamageBonus();
   //Checking to see if the attack hits
   if(results[1] == -1) {
      hitOrMiss = "MISS!";
   } else {
      hitOrMiss = "HIT!";
   }
   //Printing out the result of the attack roll and damage roll (if necessary)
   cout << "Attack roll: " << attackRoll << " + " << c1.getAttackBonus() << " = " << attackRoll + c1.getAttackBonus() << " --> " << hitOrMiss << "\n";
   if(results[1] != -1) {
      cout << "Damage: " << damageRoll << " + " << c1.getDamageBonus() << " = " << damageRoll + c1.getDamageBonus() << "\n";
      cout << c2.getName() << " has " << c2.getHealth() << " hit points remaining\n";
   }
}

/*
   battle: Starts a battle between c1 and c2 where c1 attacks first

   Parameters:
      &c1 (Character) - The character who attacks first
      &c2 (Character) - The character who attacks second

   Battle ends when either character reaches 0 HP
   If both characters start the battle with 0 HP, the second attacking character automatically wins
*/
void battle(Character &c1, Character &c2) {
   bool battleDone = false;
   cout << "Simulated Combat:\n";
   while(!battleDone) {
      //Checking to see if either player has 0 HP
      if(c1.getHealth() <= 0 || c2.getHealth() <= 0) {
         battleDone = true;
      } else {
         doTurn(c1, c2);
      }
      //Skipping c2's turn if either character is already at 0 HP
      if(battleDone) {
      //Checking to see if c2 died on c1's attack
      } else if(c2.getHealth() <= 0) {
         battleDone = true;
      } else {
         doTurn(c2, c1);
      }
   }
   //Declaring winner: Default winner if both have 0 HP is c2
   if(c1.getHealth() <= 0) {
      cout << "\n" << c2.getName() << " wins!";
   } else if(c2.getHealth() <= 0) {
      cout << "\n" << c1.getName() << " wins!";
   }
}

/*
   main: Creates both characters and runs the battle
*/
int main() {
   srand(time(NULL));
   Character player1 = createCharacter();
   Character player2 = createCharacter();
   battle(player1, player2);
}