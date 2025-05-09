// Avery Colley Project 1
// CS1181
// 9/18/2022
// The Item class stores a name, weight, value and whether or not the item
// is taken

public class Item {

   private final String name;
   private final double weight;
   private final int value;
   private boolean included;

   // Creates an Item with the given name, weight, and value
   // By default an Item is not taken
   public Item(String name, double weight, int value) {
      this.name = name;
      this.weight = weight;
      this.value = value;
      this.included = false;
   }

   // Creates an Item with the same name, weight, and value as the given Item
   // The Item created is taken if the given Item is and not taken if the given Item is not taken
   public Item(Item other) {
      this.name = other.name;
      this.weight = other.weight;
      this.value = other.value;
      this.included = other.included;
   }

   // Gets the weight of the Item
   public double getWeight() {
      return weight;
   }

   // Gets the value of the Item
   public int getValue() {
      return value;
   }

   // Returns true if the Item is taken, falso otherwise
   public boolean isIncluded() {
      return included;
   }

   // Takes in either true or false and includes the item if true, and excludes the item if false
   public void setIncluded(boolean included) {
      this.included = included;
   }

   // returns a String in the form <name> (<weight> lbs. $<value>)
   public String toString() {
      return name + "(" + weight + " lbs. $" + value + ")";
   }
}
