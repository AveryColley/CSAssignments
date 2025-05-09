// Avery Colley
// Card class keeps track of the suit and value of the Card
// a value of 14 is an Ace, 11 is a Jack, 12 is a Queen, and 13 is a King

public class Card implements Comparable<Card> {

   private String suit;
   private int value;

   // Creates a new Card object with the given suit and value
   public Card(String suit, int value) {
      this.suit = suit;
      this.value = value;
   }

   // Returns the suit of the Card
   public String getSuit() {
      return this.suit;
   }

   // Returns the value of the Card
   public int getValue() {
      return this.value;
   }

   // Returns a String in the form of "<value>-of-<suit>.png"
   public String getImageName() {
      if(this.value == 14) {
         return "A-of-" + suit + ".png";
      } else if(this.value == 11) {
         return "J-of-" + suit + ".png";
      } else if(this.value == 12) {
         return "Q-of-" + suit +".png";
      } else if(this.value == 13) {
         return "K-of-" + suit + ".png";
      } else {
         return value + "-of-" + suit + ".png";
      }
   }

   // Returns true if the suit and value of the passed in Card are the same
   public boolean equalsTo(Card o) {
      return (this.value == o.getValue() && this.suit == o.getSuit());
   }

   // Returns a positive integer if this Card has a higher value than the one given,
   // 0 if they're equal, and a negative integer otherwise (Aces high)
   public int compareTo(Card o) {
         return this.value - o.value;
   }

   // Prints out Card in the for <value> of <suit>
   public String toString() {
      return value + " of " + suit;
   }
}