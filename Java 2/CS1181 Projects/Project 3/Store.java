//Avery Colley
//Project 3
//This Class contains the actual simulation of the grocery store

import java.io.*;
import java.util.*;

public class Store {

   //Name of the file from which to take input in the form "<Arrival Time> <# of Items> <Time Per Item>"
   //Where <Arrival Time> is given in minutes after the store opened and <Time Per Item> is given in minutes
   final static String GIVEN_FILE = "arrival medium.txt";
   final static int NUM_LANES = 12;

   public static void main(String[] args) throws FileNotFoundException{
      File f = new File(GIVEN_FILE);
      ArrayList<Customer> cu = createCustomers(f);
      PriorityQueue<CheckoutLane> ch = createLanes(4, 2, 6);
      PriorityQueue<Event> eventList = makeInitialQueue(cu);
      startSim(cu, ch, eventList);
      System.out.println("Average wait time per customer: " + getAverage(ch));
      System.out.println(getMaxLines(ch));
   }

   //Creates and returns an ArrayList of Customers using the given file
   public static ArrayList<Customer> createCustomers(File f) throws FileNotFoundException{
      Scanner s = new Scanner(f);
      ArrayList<Customer> cu = new ArrayList<>();
      int i = 0;
      while(s.hasNextLine()) {
         String line = s.nextLine();
         String[] str = line.split("[\s\t]+");
         cu.add(new Customer(Double.parseDouble(str[0]), Integer.parseInt(str[1]), Double.parseDouble(str[2]), i));
         i++;
      }
      s.close();
      return cu;
   }

   //Creates and returns a PriorityQueue of Event Objects taken from an ArrayList of Customers
   //This initial PriorityQueue does not contain information about the customer actually beginning checkout or finishing checking out,
   //just information on when they arrived and when they started waiting in line
   public static PriorityQueue<Event> makeInitialQueue(ArrayList<Customer> cu) {
      PriorityQueue<Event> eq = new PriorityQueue<>();
      for (Customer c : cu) {
         eq.offer(new Event(c.getArrivalTime(), "Arriving", c.getNumber()));
         eq.offer(new Event(c.getReadyToCheckoutTime(), "Waiting", c.getNumber()));
      }
      return eq;
   }

   //Creates and returns a PriorityQueue of CheckoutLanes with the given number of regular, express, and closed lanes
   public static PriorityQueue<CheckoutLane> createLanes(int r, int e, int c) {
      PriorityQueue<CheckoutLane> ch = new PriorityQueue<>();
      for(int i = 0; i < r; i++) {
         ch.offer(new CheckoutLane(false, false));
      }
      for(int i = 0; i < e; i++) {
         ch.offer(new CheckoutLane(true, false));
      }
      for(int i = 0; i < c; i++) {
         ch.offer(new CheckoutLane(false, true));
      }
      return ch;
   }

   //Starts the grocery store simulation with a given ArrayList of customers, PriorityQueue of CheckoutLanes, and PriorityQueue of Events.
   //Ends when all the customers are finished shopping
   public static void startSim(ArrayList<Customer> cu, PriorityQueue<CheckoutLane> ch, PriorityQueue<Event> eq) {
      if(eq.isEmpty()) {
         System.out.println("Sim done");
         return;
      }

      Event e = eq.poll();
      if(e.getEventType().equals("Arriving")) {
      } else if(e.getEventType().equals("Waiting")) {
         CheckoutLane lane = cu.get(e.getCustomerNumnber()).chooseLane(ch);
         cu.get(e.getCustomerNumnber()).setCheckoutLane(lane);
         if(!lane.isBusy()) {
            eq.offer(new Event(e.getStartTime(), "Checking out", e.getCustomerNumnber()));
         }
      } else if(e.getEventType().equals("Checking out")) {
         double waitingTime = e.getStartTime() - cu.get(e.getCustomerNumnber()).getReadyToCheckoutTime();
         cu.get(e.getCustomerNumnber()).getCurrentLane().addWaitTime(waitingTime);
         eq.offer(new Event(e.getStartTime() + cu.get(e.getCustomerNumnber()).getCurrentLane().checkout(), "Done", e.getCustomerNumnber()));
      } else {
         CheckoutLane lane = cu.get(e.getCustomerNumnber()).getCurrentLane();
         if(lane != null) {
            lane.setBusy(false);
            if(!lane.getQueue().isEmpty()) {
               eq.offer(new Event(e.getStartTime(), "Checking out", lane.getQueue().peek().getNumber()));
            }
         }
      }
      System.out.println(e);
      startSim(cu, ch, eq);
   }

   //Returns the average wait time per person
   public static double getAverage(PriorityQueue<CheckoutLane> ch) {
      Stack<CheckoutLane> temp = new Stack<>();
      double totalWait = 0;
      int count = 0;
      while(!ch.peek().isClosed()) {
         CheckoutLane tempLane = ch.poll();
         totalWait += tempLane.averageWait();
         temp.push(tempLane);
         count++;
      }
      while(!temp.isEmpty()) {
         ch.offer(temp.pop());
      }
      totalWait = totalWait / (double) count;
      return Math.round(totalWait * 100.0) / 100.0;
   }

   //Takes in a PriorityQueue of CheckoutLanes and returns an Array of Strings containing
   //information about the type of lane and the max line the lane had.
   public static ArrayList<String> getMaxLines(PriorityQueue<CheckoutLane> ch) {
      ArrayList<String> lines = new ArrayList<>();
      Stack<CheckoutLane> temp = new Stack<>();
      for(int i = 0; i < NUM_LANES; i++) {
         CheckoutLane tempLane = ch.poll();
         if(tempLane.isExpress()) {
            lines.add("This express lane had a max line of: " + tempLane.getMaxCount());
         } else if(tempLane.isClosed()) {
            lines.add("This lane was closed");
         } else {
            lines.add("This regular lane had a max line of: " + tempLane.getMaxCount());
         }
         temp.push(tempLane);
      }
      while(!temp.isEmpty()) {
         ch.offer(temp.pop());
      }
      return lines;
   }
}