/* Avery Colley
 * This is a thread to write 100 bytes of input to a pipe and write the output into a text file called "PipeOutput.txt"
*/

import java.io.*;
import java.util.*;

public class PipeWriteThread extends Thread {
   private Random r;
   private PipedOutputStream output;
   private FileWriter fw;

   //Constructor - Takes in a PipedOutputStream
   public PipeWriteThread(PipedOutputStream output) {
      this.output = output;
      r = new Random();
      try {
         fw = new FileWriter("PipeOutput.txt"); //Creating the text file
      } catch (IOException e) {
         System.out.println("Something went wrong creating the file");
      }
   }

   //run - runs the thread
   public void run() {
      int j; //Placeholder int for writing to the pipe
      for(int i = 0; i < 100; i++) {
         j = r.nextInt(255); //Random integer from 0-255
         try {
            fw.write(j + "\n"); //Writes the integer to the file
            output.write(j); //Writes the integer to the pipe
         } catch (IOException e) {
            System.out.println("Something went wrong writing to the file/pipe");
         }
      }
      try {
         fw.close(); //Closes the FileWriter
      } catch(IOException e) {
         System.out.println("Something went wrong closing the FileWriter");
      }
      System.out.println("Writing done");
   }
}