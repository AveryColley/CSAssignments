//Avery Colley
//Practice problem 08

public class Sum {
   public static void main(String[] args) {
      System.out.println(sumDigits(123456L));
   }

   public static long sumDigits(long n) {
      if(n <= 9) {
         return n;
      }

      long summedN = 0L;
      for(char c : Long.toString(n).toCharArray()) {
         summedN += Character.getNumericValue(c);
      }

      return sumDigits(summedN);
   }
}
