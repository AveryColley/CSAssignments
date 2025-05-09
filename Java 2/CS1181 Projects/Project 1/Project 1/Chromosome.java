// Avery Colley Project 1
// CS1181
// 9/18/2022
// The Chromosome Class stores an ArrayList of Items and allows "crossover" with
// other Chromosome Classes. Each Chromosome has a related "fitness" related to the
// total value of items.

import java.util.*;

public class Chromosome extends ArrayList<Item> implements Comparable<Chromosome> {

   private static Random rng = new Random();

   // Constructs an Empty Chromosome
   public Chromosome() {
   }

   // Constructs a Chromosome given an ArrayList of Item. Whether or not a specific
   // item is considered included is random.
   public Chromosome(ArrayList<Item> items) {
      for(Item e : items) {
         int r = rng.nextInt(10) + 1;
         e.setIncluded(r <= 5);
         Item copy = new Item(e);
         this.add(copy);
      }
   }

   // Creates and returns a new "child" Chromosome by randomly deciding which
   // items from its parents the child inherits
   public Chromosome crossover(Chromosome other) {
      Chromosome child = new Chromosome();
      for(int i = 0; i < other.size(); i++) {
         int r = rng.nextInt(10) + 1;
         if(r <= 5) {
            Item copy = new Item(this.get(i));
            child.add(copy);
         } else {
            Item copy = new Item(other.get(i));
            child.add(copy);
         }
      }
      return child;
   }

   // For each Item in this Chromosome, randomly decide to change whther or
   // not the Item is considered to be included
   public void mutate() {
      for(Item e : this) {
         int r = rng.nextInt(10) + 1;
         if (r == 1) {
            e.setIncluded(!e.isIncluded());
         }
      }
   }

   // Returns the fitness value of the Chromosome (i.e. the total value of the Items contained within it)
   // returns 0 when the total weight exceeds 10
   public int getFitness() {
      double weight = 0;
      int fitness = 0;
      for(Item e : this) {
         if(e.isIncluded()) {
            weight += e.getWeight();
            fitness += e.getValue();
         }
      }
      if(weight > 10) {
         return 0;
      } else {
         return fitness;
      }
   }

   // A Chromosome is considered "less than" another Chromosome if it has a higher fitness
   public int compareTo(Chromosome other) {
      if(this.getFitness() > other.getFitness()) {
         return -1;
      } else if(this.getFitness() == other.getFitness()) {
         return 0;
      } else {
         return 1;
      }
   }

   // Returns a String in the form [Item1, Item2, ... , fitness: X]
   public String toString() {
      ArrayList<String> current = new ArrayList<>();
      for(Item e : this) {
         if(e.isIncluded()) {
            current.add(e.toString());
         }
      }
      current.add("fitness: " + this.getFitness());
      return current.toString();
   }
}
