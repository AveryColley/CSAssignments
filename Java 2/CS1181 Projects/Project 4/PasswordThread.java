//The PasswordThread class to be used with Password Cracker

import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import net.lingala.zip4j.core.*;
import net.lingala.zip4j.exception.*;

public class PasswordThread extends Thread {

   //The passwords to check
   private ArrayList<String> pw;
   //The characters allowed in the passwords
   private ArrayList<String> letters;
   //Name of the file
   private String name;
   //Length of the password to guess
   private int pwLength;
   //Tells the PasswordThreads when to stop
   private static volatile boolean solved;
   //The file to be opened
   private ZipFile zipfile;
   //Which PasswordThread this is
   private int num;

   //Generates a list of passwords to try of length pwLength and then tries them all until the folder is open
   public void run() {
      genPasswords(pwLength - 1);
      tryPasswords();
   }

   //Generates a PasswordThread and initializes all of the fields to be what are defined here
   public PasswordThread(ArrayList<String> pw, ArrayList<String> letters, String name, int pwLength, int num, boolean solved) {
      this.pw = pw;
      this.letters = letters;
      this.name = name;
      this.pwLength = pwLength;
      this.num = num;
      try {
         this.zipfile = new ZipFile(name);
      } catch(ZipException ze) {
        System.out.println(ze);
      }
   }

   //Changes the pw ArrayList to include all possible password combinations from the letters ArrayList
   public void genPasswords(int length) {
      if(length <= 0) {
         pw.trimToSize();
         return;
      }

      int tempLength = pw.size();
      for(int i = 0; i < tempLength; i++) {
         for(String s: letters) {
            pw.add(pw.get(i) + s);
         }
      }
      for(int i = 0; i < tempLength; i++) {
         pw.remove(0);
      }
      genPasswords(length - 1);
   }

   //Trys each password in pw to see if it opens the file, if the file is already opened, the method returns
   public void tryPasswords() {
      for(String s : pw) {
         if(solved) {
            return;
         }
         if(checkPassword(s)) {
            return;
         }
      }
   }

   //Takes in a String and uses it to try and guess the password to the zipfile made in the constructor
   public boolean checkPassword(String s) {
      //Try-Catch block taken from Example.java
      try {
         zipfile.setPassword(s);
         zipfile.extractAll("contents-" + num);
         System.out.println("Successfully cracked!");
         System.out.println("Correct password is: " + s);
         solved = true;
         return true;
      } catch (ZipException ze) {
      } catch (Exception e){
         e.printStackTrace();
      }
      return false;
   }
}
