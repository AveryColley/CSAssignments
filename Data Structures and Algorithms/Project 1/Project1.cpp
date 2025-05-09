/*
   Avery Colley
   Project #1 - Simulating Dice Rolls
   This file allows the user to input an amount of dice rolls they want to simulate
   and then prints out the result of the rolls

   Constants:
      DICE_FACES:  Positive integer repesenting The number of faces on each individual die
      DICE_NUMBER: Non-negative number of dice that are being rolled together
*/

#include <iostream>
#include <cstdlib>
#include <time.h>

using namespace std;

const int DICE_FACES = 100;
const int DICE_NUMBER = 1;

/*
   rollDice: Rolls DICE_NUMBER of DICE_FACES-sided dice a specified number of times
             and prints out the results

   Parameters:
      trials (integer) - The number of times to roll the dice
         Assumed to be positive

   This function assumes that DICE_FACES is positive and DICE_NUMBER is non-negative
*/
void rollDice(int trials) {
   const int values = ((DICE_FACES * DICE_NUMBER) - DICE_NUMBER + 1);
   int rolls[values];
   int average = 0;

   //Initializing the rolls array to zero
   for(int i = 0; i < values; i++) {
      rolls[i] = 0;
   }

   cout << "simulating " << trials << " rolls..." << "\n";

   for(int i = 0; i < trials; i++) {
      int result = 0;
      for(int j = 0; j < DICE_NUMBER; j++) {
         result += (rand() % DICE_FACES + 1);
      }
      rolls[(result - DICE_NUMBER)] += 1;
   }

   // Printing results
   for(int i = 0; i < values; i++) {
      if(rolls[i] != 0) {
         cout << DICE_NUMBER + i << " was rolled " << rolls[i] << " times\n";
      }
   }

   delete [] rolls;
}

/*
   main: Prompts the user for the amount of trials to run and then runs that many trials
*/
int main() {
   string trials;
   bool valid = false;
   cout << trials.size() << "\n";
   cout << "How many rolls?  ";
   //cin >> trials;
   //cout << trials.size() << "\n";

   srand(time(NULL));
   // rollDice(10);

   while(!valid) {
      cin >> trials;
      for(int i = 0; i < trials.size(); i++) {
         if(!isdigit(trials[i])) {
            valid = false;
            cout << "Please enter a valid integer: ";
            break;
         } else {
            valid = true;
         }
      }
   }


   if(isdigit(trials[0])) {
      cout << "true" << "\n";
   } else {
      cout << "false" << "\n";
   }
}
