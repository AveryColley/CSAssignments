/* Avery Colley
 * This is a multithreaded program to write and read random integers from a buffer using a Semaphore
 */
import java.io.*;
import java.util.concurrent.*;
import java.util.*;

//Data to be shared between threads
class SharedData {
   static int count = 0; //Amount of items currently in the buffer
   static int in = 0; //Index to place the next item into the buffer
   static int out = 0; //Index to read the next item from the buffer
   static int[] buffer = new int[10]; //The buffer itself
}

//Class to create a Thread that reads and writes from and to the buffer
class SemaphoreThread extends Thread {
   private Semaphore s;
   private boolean write; //True if the thread if meant for writing to the buffer, false otherwise
   private boolean done; //Whether or not the Thread has written/read 100 items
   private int totalCount; //Total amount of items written/read
   private FileWriter fw;

   //Constructor - Takes a given Semaphore and a boolean value. This boolean is true if the thread is meant to write to the buffer, and false otherwise
   public SemaphoreThread(Semaphore s, boolean write) {
      this.write = write;
      this.s = s;
      done = false;
      totalCount = 0;
      try {
         if (write) {
            fw = new FileWriter("SemaphoreOutput.txt"); //Creating the output file
         } else {
            fw = new FileWriter("SemaphoreInput.txt"); //Creating the input file
         }
      } catch (IOException e) {
         System.out.println("Something with wrong with creating the file");
      }
   }

   //run - Runs the thread, either writes 100 random integers to both the buffer and the text file, or reads 100 integers from the buffer and writes them to a text file
   public void run() {
      if(write) { //Thread is meant for writing
         Random r = new Random(); //For generating random integers
         while(!done) {
            if(s.tryAcquire()) { //Try to acquire a permit from the Semaphore if one is available
               while(true) {
                  if(SharedData.count == 10) { //Buffer is full
                     //Do nothing
                     break;
                  } else { //Buffer is not full
                     SharedData.buffer[SharedData.in] = r.nextInt(); //Places a random integer into the buffer
                     try {
                        fw.write(SharedData.buffer[SharedData.in] + "\n"); //Writes the integer to the text file
                     } catch (IOException e) {
                        System.out.println("Something went wrong writing to \"SemaphoreOutput.txt\"");
                     }
                     SharedData.in = (SharedData.in + 1) % 10; //Increments in
                     SharedData.count++; //Updates count of items in buffer
                     totalCount++; //Updates total number of integers written to the buffer
                  }
               }
               s.release(); //Releases the permit
            }
            if(totalCount == 100) { //Written 100 integers
               System.out.println("Writing done");
               done = true;
            }
         }
      } else { //Thread is for reading
         while(!done) {
            if(s.tryAcquire()) { //Try to acquire a permit from the Semaphore if one is available
               while(true) {
                  if(SharedData.count == 0) { //Buffer is empty
                     //Do nothing
                     break;
                  } else {
                     try {
                        fw.write(SharedData.buffer[SharedData.out] + "\n"); //Writing the next integer to the text file
                     } catch (IOException e) {
                        System.out.println("Something went wrong writing to \"SemaphoreInput.txt\"");
                     }
                     SharedData.out = (SharedData.out + 1) % 10; //Incrementing out
                     SharedData.count--; //Updating count of items in the buffer
                     totalCount++; //Updating total count of items read from the buffer
                  }
               }
               s.release(); //Releases the permit
            }
            if(totalCount == 100) { //Read 100 integers
               System.out.println("Reading done");
               done = true;
            }
         }
      }
      try {
         fw.close(); //Closing the FileWriter
      } catch(IOException e) {
         System.out.println("Something went wrong closing the FileWriter");
      }
   }
}

public class SemaphoreMain {
   //Main method for starting the threads
   public static void main(String[] args) throws IOException {
      Semaphore s = new Semaphore(1);

      SemaphoreThread wr = new SemaphoreThread(s, true); //Writing thread
      SemaphoreThread re = new SemaphoreThread(s, false); //Reading thread

      //Starting the threads
      wr.start();
      re.start();
   }
}