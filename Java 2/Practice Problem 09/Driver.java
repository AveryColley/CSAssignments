// Avery Colley
// Practice Problem 09

import java.util.*;

public class Driver {
   public static void main(String[] args) throws InterruptedException{
      Scanner s = new Scanner(System.in);
      System.out.println("How many Threads? ");
      int threadCount = s.nextInt();
      s.nextLine();
      System.out.println("Maximum number for counting primes: ");
      int n = s.nextInt();
      s.nextLine();
      s.close();
      int newStart = 1;
      int newEnd = n / threadCount;
      PrimeThread[] names = new PrimeThread[threadCount];
      for(int i = 0; i < threadCount ; i++) {
         names[i] = new PrimeThread(newStart, newEnd);
         System.out.println(newStart);
         System.out.println(newEnd);
         newStart = newEnd;
         newEnd = newEnd + newEnd;
         if(newEnd > n) {
            newEnd = n;
         }
      }
      long startTime = System.currentTimeMillis();
      int totalPrimes = 0;
      for(PrimeThread p : names) {
         p.start();
      }
      for(PrimeThread p : names) {
         totalPrimes += p.getCount();
      }
      long endTime = System.currentTimeMillis();
      for(PrimeThread p :names) {
         p.join();
      }
      System.out.println("Time to run with " + threadCount + " Threads: " + (endTime - startTime) + "ms");
      System.out.println("This many primes: " + totalPrimes);
   }
}
