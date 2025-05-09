/* Avery Colley
* This is the main program for the Pipe method of the final project
*/

import java.io.*;

public class PipeMain {
   public static void main(String[] args) throws IOException {
      final PipedOutputStream output = new PipedOutputStream(); //PipeOutputStream to write integers to
      final PipedInputStream input = new PipedInputStream(output); //PipeInputStream to read integers from, connected to output

      PipeWriteThread wt = new PipeWriteThread(output); //Writing Thread
      PipeReadThread rt = new PipeReadThread(input); // Reading Thread

      wt.start(); //Writing Thread start
      rt.start(); // Reading Thread start
   }
}