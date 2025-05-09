//Avery Colley

public class NecessaryItem extends Product {

  public NecessaryItem(String name, double price) {
    super(name, price);
  }

  public double getTotalPrice() {
    return super.getPrice();
  }
}