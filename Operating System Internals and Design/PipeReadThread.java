/* Avery Colley
 * This is a thread to read 100 bytes of input from a pipe and write the given input into a text file called PipeInput.txt"
*/

import java.io.*;

public class PipeReadThread extends Thread {
   private PipedInputStream input;
   private FileWriter fw;

   //Constructor - Takes a PipedInputStream
   public PipeReadThread(PipedInputStream input) {
      this.input = input;
      try {
         fw = new FileWriter("PipeInput.txt"); //Creating the text file
      } catch (IOException e) {
         System.out.println("Something went wrong creating the file");
      }
   }

   //Run - runs the thread
   public void run() {
      int j; //Placeholder int for writing to the file
      for(int i = 0; i < 100; i++) {
         try {
            j = input.read(); //Reads the first byte from the pipe
            fw.write(j + "\n"); //Writes the data to the file
         } catch (IOException e) {
            System.out.println("Something went wrong reading from the pipe or writing to the file");
         }
      }
      try {
         fw.close(); //Closes the FileWriter
      } catch(IOException e) {
         System.out.println("Something went wrong closing the FileWriter");
      }
      System.out.println("Reading done");
   }
}