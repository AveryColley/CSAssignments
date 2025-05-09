//Avery Colley

public class ShoppingTripStartingCode {

    public static void main(String[] args) {

        Product[] products = new Product[4];
        Product n1 = new NecessaryItem("N1", 1.50);
        Product l1 = new LuxuryItem("L1", 3.50);
        Product n2 = new NecessaryItem("N2", 2.25);
        Product l2 = new LuxuryItem("L2", 2.00);
        products[0] = n1;
        products[1] = l1;
        products[2] = n2;
        products[3] = l2;
        double total = 0;
        for (Product p : products) {
            System.out.println(p);
            total += p.getTotalPrice();
        }
        System.out.println("The total cost is $" + total);
    }

}
