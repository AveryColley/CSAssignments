// Avery Colley Project 1
// CS1181
// 9/18/2022
// The program that runs a specific "genetic algorithm" using Chromosomes created with a given file of items

import java.io.*;
import java.util.*;

public class GeneticAlgorithm {

   // Runs the genetic algorithm for a certain amount of generations and prints the final generation
   public static void main(String[] args) throws FileNotFoundException {
      Random rng = new Random();
      ArrayList<Item> items = readData("items.txt");
      ArrayList<Chromosome> currentPopulation = initializePopulation(items, 10);
      ArrayList<Chromosome> nextGeneration = new ArrayList<>();
      for(int i = 0; i < 20; i++) {
         nextGeneration.clear();
         for(Chromosome e : currentPopulation){
            nextGeneration.add(e);
         }
         int pairing = 10;
         while(pairing != 0) {
            Chromosome child = currentPopulation.remove(rng.nextInt(pairing)).
               crossover(currentPopulation.remove(rng.nextInt(pairing - 1)));
            nextGeneration.add(child);
            pairing -= 2;
         }
         nextGeneration.get(rng.nextInt(15)).mutate();
         Collections.sort(nextGeneration);
         currentPopulation.clear();
         for(int k = 0; k < 10; k++) {
            currentPopulation.add(nextGeneration.get(k));
         }
      }
      Collections.sort(currentPopulation);
      System.out.println(currentPopulation);
   }

   // Initializes a population of Chromosomes of a given size using a given ArrayList of Item
   public static ArrayList<Chromosome> initializePopulation(ArrayList<Item> items, int populationSize) {
      ArrayList<Chromosome> population = new ArrayList<Chromosome>();
      for(int i = 0; i < populationSize; i++) {
         population.add(new Chromosome(items));
      }
      return population;
   }

   // Reads in a file of the form:
   //          Item name, Item weight, Item value
   //          Item name, Item weight, Item value
   //          ...
   // And Creates an ArrayList of Item that includes each Item in the given file.
   public static ArrayList<Item> readData(String filename) throws FileNotFoundException {
      ArrayList<Item> items = new ArrayList<>();
      File f = new File(filename);
      Scanner s = new Scanner(f);
      s.useDelimiter(",\s|\\n");
      while(s.hasNext()) {
         Item e = new Item(s.next(), s.nextDouble(), s.nextInt());
         items.add(e);
      }
      s.close();
      return items;
   }

}
