//the Event Class stores information about a given event that the Customer goes through
//and what Customer went through the event

public class Event implements Comparable<Event> {

   private double startTime;
   //eventType is one of {Arriving, Waiting, Checking out, Done}
   private String eventType;
   private int customerNumber;

   //Creates a new Event with the given starting time, event type, and customer number of the Customer who started the Event
   public Event(double startTime, String eventType, int customerNumber) {
      this.startTime = Math.round(startTime * 100.0) / 100.0;
      this.eventType = eventType;
      this.customerNumber = customerNumber;
   }

   //Returns the time this Event starts (in minutes)
   public double getStartTime() {
      return startTime;
   }

   //Returns the type of Event this is from one of four options:
   //Arriving, Waiting, Checking out, Done
   public String getEventType() {
      return eventType;
   }

   //Returns the number of the Customer who started this Event
   public int getCustomerNumnber() {
      return customerNumber;
   }

   //Returns -1 if this Event starts before the given Event, 1 if this Event starts later, and 0 otherwise
   public int compareTo(Event o) {
      if(o.getStartTime() > this.startTime) {
         return -1;
      } else if(o.getStartTime() < this.startTime) {
         return 1;
      } else {
         return 0;
      }
   }

   //Returns a String with information on the Event
   public String toString() {
      return "At " + startTime + " minutes, customer " + customerNumber + " is: " + eventType;
   }
}