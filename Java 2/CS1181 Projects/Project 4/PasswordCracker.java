//Avery Colley
//Project 4
//This program take a number of threads and brute forces a password on a given zipfile name

import net.lingala.zip4j.core.*;
import net.lingala.zip4j.exception.*;
import java.util.ArrayList;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class PasswordCracker {
   //Number of threads to use
   final static int numThreads = 26;
   //Length of password
   final static int PASSWORD_LENGTH = 5;
   //Name of zip file
   final static String FILE_NAME = "protected5.zip";
   //Tells the threads when to stop (i.e. the password has been cracked)
   static volatile boolean solved = false;
   public static void main(String[] args) throws InterruptedException{
      ArrayList<PasswordThread> pw = genThreads(numThreads);
      long startTime = System.currentTimeMillis();
      for(PasswordThread pt : pw) {
         pt.start();
      }
      for(PasswordThread pt : pw) {
         pt.join();
      }
      System.out.println("Time it took to crack the password: " + ((System.currentTimeMillis() - startTime) / 1000.0) + "s");
   }

   //Takes an integer n and returns an ArrayList of lowercase characters, starting with the "min"th and ending with the "max"th letters
   public static ArrayList<String> genChar(int min, int max) {
      ArrayList<String> characters = new ArrayList<>();
      for(char c = (char) (97 + min); c < 'a' + max; c++) {
         characters.add("" + c);
      }
      return characters;
   }

   //Returns an ArrayList of n PasswordThreads giving them the values declared ealier before main
   public static ArrayList<PasswordThread> genThreads(int n) {
      ArrayList<PasswordThread> threads = new ArrayList<>();
      int[] positions = new int[n];
      int initSpace = 26 / n;
      int space = initSpace;
      int j = 0;
      if(n == 1) {
         positions[0] = 26;
      } else {
         while(space < 26) {
            positions[j] = space;
            j++;
            if(initSpace * n != 26) {
               space = space + initSpace + 1;
            } else {
            space += initSpace;
            }
            if(space >= 26) {
               positions[j] = 26;
            }
         }
      }
      String title = copyFile(0);
      threads.add(new PasswordThread(genChar(0, positions[0]), genChar(0, 26), title, PASSWORD_LENGTH, 0, solved));
      for(int i = 1; i < n; i++) {
         String newName = copyFile(i);
         threads.add(new PasswordThread(genChar(positions[i - 1], positions[i]), genChar(0, 26), newName, PASSWORD_LENGTH, i, solved));
      }
      return threads;
   }

   //Copies the Encrypted file for each PasswordThread so that they aren't all accessing the same file and the same time
   public static String copyFile(int num) {
      try {
         File sourceFile = new File(FILE_NAME);
         File destinationFile = new File("protected5-" + num + ".zip");
         Files.copy(sourceFile.toPath(), destinationFile.toPath());
         return "protected5-" + num + ".zip";
      } catch (IOException ioe) {
         System.out.println(ioe);
         return "";
      }
   }
}
