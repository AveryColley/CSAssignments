//Avery Colley

import java.lang.Math;

public class LuxuryItem extends Product {

   public LuxuryItem(String name, double price) {
    super(name, price);
  }

  public double getTotalPrice() {
    return (Math.round((super.getPrice() * 1.0575) * 100) / 100.0);
  }
}