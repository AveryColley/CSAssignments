//The CheckoutLane Class hold information about a specific CheckoutLane in the store, including
//whether or not the Lane is express or closed, the current line of Customers waiting,
//The total amount of Customers that have passed through the Lane, the current amount of Customers waiting,
//how long it takes the lane to process each item and payment(in minutes), and whtther or not the lane is busy.

import java.util.*;
import java.util.LinkedList;

public class CheckoutLane implements Comparable<CheckoutLane> {

   private boolean express;
   private Queue<Customer> q;
   private boolean closed;
   private double waitTime;
   private int totalCount;
   private int count;
   private int maxCount;
   private double itemTime;
   private double paymentTime;
   private boolean busy;

   //Creates a new CheckoutLane that is either express, regular, or closed
   //Closed lanes have a current line of 9999 people
   public CheckoutLane(boolean express, boolean closed) {
      this.express = express;
      this.closed = closed;
      this.waitTime = 0;
      this.count = 0;
      this.maxCount = 0;
      this.totalCount = 0;
      this.busy = false;
      this.q = new LinkedList<>();
      if(express) {
         this.itemTime = 0.1;
         this.paymentTime = 1;
      } else if(closed) {
         this.count = 9999;
      } else {
         this.itemTime = .05;
         this.paymentTime = 2;
      }
   }

   //Adds a customer to the line in this particular CheckoutLane
   public void add(Customer c) {
      q.offer(c);
      totalCount++;
      count++;
      if(count > maxCount) {
         maxCount = count;
      }
   }

   //Returns time it took for given customer to checkout. Returns -1 if lane is closed or checkout is called on an empty Lane
   //Also removes the customer from the line of the Lane
   public double checkout() {
      if(closed) {
         return -1;
      }
      if(!q.isEmpty()) {
         count--;
         this.busy = true;
         return (q.poll().getItems() * itemTime) + paymentTime;
      } else {
         return -1;
      }
   }

   //Adds the given amount of time to the total time waited in this specific CheckoutLane
   public void addWaitTime(double time) {
      waitTime += time;
   }

   //Returns the average wait time for this specific CheckoutLane
   public double averageWait() {
      return waitTime / (double) totalCount;
   }

   //Sets whether the lane should be busy or not
   public void setBusy(boolean newBusy) {
      this.busy = newBusy;
   }

   //Returns true if the lane is express
   public boolean isExpress() {
      return express;
   }

   //Returns true if the lane is closed
   public boolean isClosed() {
      return closed;
   }

   //Returns current amount of time waited in this specific CheckoutLane
   public double getWaitTime() {
      return waitTime;
   }

   //Returns the current amount of customers in the line at this CheckoutLane
   public int getCount() {
      return count;
   }

   //Returns the highest amount of customers in the line that this CheckoutLane has dealt with
   public int getMaxCount() {
      return maxCount;
   }

   //Returns the current line of customers
   public Queue<Customer> getQueue() {
      return q;
   }

   //returns the total amount of customers that have passed through this CheckoutLane
   public int getTotalCount() {
      return totalCount;
   }

   //Returns true if lane is busy, false otherwise
   public boolean isBusy() {
      return busy;
   }

   //Returns a negative integer if the given checkoutLane has more people waiting in line than this one,
   //a positive integer if this checkoutLane has more people waiting in line than the other one, and zero otherwise
   public int compareTo(CheckoutLane o) {
      return this.count - o.getCount();
   }

   //Returns a String stating what type of lane this is
   public String toString() {
      if(express && !closed) {
         return "Express lane";
      } else if(!express && !closed) {
         return "Regular lane";
      } else {
         return "Closed lane";
      }
   }
}