// Avery Colley
// Practice Problem 3
// 9/22/22

import java.util.*;

public class ExceptionalDivision {

   public static void main(String[] args) {
      Scanner s = new Scanner(System.in);
      int num;
      int denom;
      while(true) {
      System.out.println("Please enter a numerator");
         try {
            num = s.nextInt();
            break;
         } catch(Exception e) {
            System.out.println("Error: you must enter a whole number");
            s.next();
         }
      }
      while(true) {
         System.out.println("Please enter a denominator");
         try {
            denom = s.nextInt();
            if(denom == 0) {
               System.out.println("Error: the denominator can't be zero");
            } else {
               break;
            }
         } catch(Exception e) {
            System.out.println("Error: you must enter a whole number");
            s.next();
         }
      }
      System.out.println(num + " / " + denom + " = " + num/denom);
      s.close();
   }
}