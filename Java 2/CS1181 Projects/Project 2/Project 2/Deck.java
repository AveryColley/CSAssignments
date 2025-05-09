// Avery Colley
// Deck class keeps track of a standard 52 card deck of playing cards

import java.util.ArrayList;

public class Deck {

   private ArrayList<Card> deck = new ArrayList<>();

   // Creates a new Deck and populates it with Ace through King. Cards of the same value are
   // clumped together in the order Spades, Hearts, Clubs, Diamonds
   public Deck() {
      for(int i = 2; i <= 14; i++) {
         deck.add(new Card("S", i));
         deck.add(new Card("H", i));
         deck.add(new Card("C", i));
         deck.add(new Card("D", i));
      }
   }

   // Removes and returns the Card object at the given index of the Deck
   public Card removeCard(int i) {
      return this.deck.remove(i);
   }

   // Removes and returns a specific Card from the Deck
   public Card removeSpecificCard(int j) {
      for(int i = 0; i <= this.deck.size(); i++) {
         if(this.deck.get(i).getValue() == j) {
            return this.deck.remove(i);
         }
      }
      return new Card("Error", -1);
   }

   // Prints out the Deck in the form [Card1, Card2, ... , Card52]
   public String toString() {
      return deck.toString();
   }
}
