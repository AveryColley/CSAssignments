// Avery Colley
// Practice Problem 07
// This assumes the user always inputs an integer when entering the number of cookies, how sweet they are, and the minimum
// desired sweetness. It also will only take the first n cookies with given sweetness values where n is the amount of cookies the user
// specified.

import java.util.*;

public class Cookies {
   public static void main(String[] args) {
      Scanner s = new Scanner(System.in);
      System.out.print("How many cookies are there? ");
      int count = s.nextInt();
      s.nextLine();
      System.out.print("What are the current sweetness values of these " + count + " cookies? ");
      String sweetnesses = s.nextLine();
      System.out.print("What is the minimum desired sweetness? ");
      int min = s.nextInt();
      s.nextLine();

      int[] sw = new int[count];
      String[] str = sweetnesses.split("[^0-9]+");
      for(int i = 0; i < count; i++) {
         sw[i] = Integer.parseInt(str[i]);
      }

      System.out.println("The number of operations required to achieve this is " + makeSweeter(sw, min));
      s.close();
   }

   public static int makeSweeter(int[] ck, int min) {
      if(ck.length == 0) {
         return -1;
      }
      PriorityQueue<Integer> q = new PriorityQueue<>();
      int operations = 0;
      for(int i : ck) {
         q.offer(i);
      }
      while(!q.isEmpty()) {
         if(q.peek() >= min) {
            return operations;
         } else if(q.size() == 1) {
            return -1;
         }
         int sweetness = (1 * q.poll()) + (2 * q.poll());
         q.offer(sweetness);
         operations++;
      }
      return operations;
   }
}
