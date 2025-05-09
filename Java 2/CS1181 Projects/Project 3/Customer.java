//The Customer Class holds data about a Customer, including a number, when they arrived at the store (in minutes),
//how many items the purchase, how long it takes them to pick out each item (in minutes),
//how long it takes them to be ready to checkout(in minutes after the store has been opened),
//and the current CheckoutLane the customer is waiting in (null if in no lane)

import java.util.*;

public class Customer {

   private int number;
   private double arrivalTime;
   private int items;
   private double selectionTime;
   private double readyToCheckoutTime;
   private CheckoutLane currentLane;

   //Creates a Customer with the given arrival time, number of items to purchase, average time
   //per item, and assigns the customer a given number
   public Customer(double arrivalTime, int items, double selectionTime, int number) {
      this.number = number;
      this.arrivalTime = arrivalTime;
      this.items = items;
      this.selectionTime = selectionTime;
      this.currentLane = null;
      this.readyToCheckoutTime = arrivalTime + (items * selectionTime);
   }

   //Takes a PriorityQueue of CheckoutLanes and picks the Lane with the shortest Line,
   //only allowing customers with 12 or fewer items to use an express lane and adds the Customer
   //to that lane. Also returns the CheckoutLane that the customer chose
   public CheckoutLane chooseLane(PriorityQueue<CheckoutLane> lanes) {
      Stack<CheckoutLane> temp = new Stack<>();
      int min = lanes.peek().getCount();
      boolean express = false;
      CheckoutLane chosenLane = lanes.peek();
      while(min == lanes.peek().getCount() && !lanes.isEmpty()) {
         if(items <= 12) {
            if(lanes.peek().isExpress()) {
               express = true;
            }
            temp.push(lanes.poll());
         } else {
            if (lanes.peek().isExpress()) {
               temp.push(lanes.poll());
               if(!temp.isEmpty()) {
               } else {
                  min = lanes.peek().getCount();
               }
            } else {
               temp.push(lanes.poll());
            }
         }
      }
      while(!temp.isEmpty()) {
         if(items <= 12 && express) {
            if(temp.peek().isExpress()) {
               chosenLane = temp.peek();
               lanes.offer(temp.pop());
            } else {
               lanes.offer(temp.pop());
            }
         } else {
            if(temp.peek().isExpress()) {
               lanes.offer(temp.pop());
            } else {
               chosenLane = temp.peek();
               lanes.offer(temp.pop());
            }
         }
      }
      chosenLane.add(this);
      return chosenLane;
   }

   //Sets the CheckoutLane the Customer is waiting in
   public void setCheckoutLane(CheckoutLane newLane) {
      this.currentLane = newLane;
   }

   //Returns the arrival time of the Customer
   public double getArrivalTime() {
      return arrivalTime;
   }

   //Returns the number of items the Customer is buying
   public int getItems() {
      return items;
   }

   //Returns the amount of time it takes the customer to pick out each item
   public double getSelectionTime() {
      return selectionTime;
   }

   //Returns the time it takes the customer to get ready for checkout
   public double getReadyToCheckoutTime() {
      return readyToCheckoutTime;
   }

   //Returns the Customer's assigned number
   public int getNumber() {
      return number;
   }

   //Returns the current CheckoutLane the customer is waiting in and null if they are not waiting or checking out
   public CheckoutLane getCurrentLane() {
      return this.currentLane;
   }

   //Returns a String containing information about the Customer's number, when they arrived, how many items they purchased,
   //how long it takes them to pick out each item, and when they were ready to checkout
   public String toString() {
      return "Customer " + number + " got here " + arrivalTime + " minutes after the store opened and bought " + items + " items," +
       "taking an average of " + selectionTime + " minutes to pick out each item and was ready to checkout " + readyToCheckoutTime +
       " minutes after the store opened";
   }
}