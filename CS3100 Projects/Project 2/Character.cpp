/*
   Jacob Colley
   This file inclues all of the functions for the Character class
*/

#include "Character.h"
#include <iostream>
#include <cstdlib>

using namespace std;

//Default constructor: initializes everything to invalid values
Character::Character() {
   name = "invalid";
   role = "invalid";
   hp = -1;
   attackBonus = -1;
   damageBonus = -1;
   ac = -1;
}

//Parameterized constructor, sets every value to what's given
Character::Character(string newName, string newRole, int newHP, int newAttack, int newDamageBonus, int newAC) :
   name(newName), role(newRole), hp(newHP), attackBonus(newAttack), damageBonus(newDamageBonus), ac(newAC) {
}

//Getters
int Character::getHealth() {
   return hp;
}

string Character::getName() {
   return name;
}

string Character::getRole() {
   return role;
}

int Character::getAttackBonus() {
   return attackBonus;
}

int Character::getDamageBonus() {
   return damageBonus;
}

int Character::getAC() {
   return ac;
}

/*
   attack: rolls a d20 and adds the characters attack bonus to see if that exceeds the other characters
           armor class, and if so damages the other character for 1d10 + this characters damage bonus

   Parameters:
      &otherCharacter (Character) - The character being attacked

   Returns:
      int* - A pointer to a size 2 array where the first slot is the result from the hit roll and the
             second slot is the result from the damage roll
*/
int* Character::attack(Character &otherCharacter) {
   int damageRoll = -1;
   static int values[2];
   int hit = (rand() % 20 + 1) + attackBonus;
   //Checking for a hit in order to roll for damage
   if(hit >= otherCharacter.ac) {
      damageRoll = (rand() % 10 + 1) + damageBonus;
      otherCharacter.damage(damageRoll);
   }
   values[0] = hit;
   values[1] = damageRoll;
   return values;
}

/*
   damage: damages this character for the given amount

   Parameters:
      amount (int) - The amount to damage this character by

   If the character would be reduced to an HP value less than 0, sets HP to 0
*/
void Character::damage(int amount) {
   if(hp - amount <= 0) {
      hp = 0;
   } else {
      hp = hp - amount;
   }
}

/*
   print: Prints out the character and all of the stats

   Parameters:
      &os (ostream) - The output to print to
*/
void Character::print(ostream &os) {
   os << "\nCharacter summary\n";
   os << "-----------------\n";
   os << name << " the " << role << "\n";
   os << "HP: " << hp << "\n";
   os << "AB: " << attackBonus << "\n";
   os << "DB: " << damageBonus << "\n";
   os << "AC: " << ac << "\n\n";
}