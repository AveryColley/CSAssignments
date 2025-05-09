// Avery Colley
// Practice Problem 06

class Main {

  public static void main(String[] args) {
    /*
    theChain is 3, 4, 7, 6, 3, 2, 9, 6, 3, 6
    */
    LinkedList list = new LinkedList();

    list.add(3);
    list.add(3);
    list.add(3);
    list.add(4);
    list.add(7);
    list.add(6);
    list.add(3);
    list.add(2);
    list.add(9);
    list.add(6);
    list.add(3);
    list.add(6);

    list.removeN(3, 2);
    list.removeN(3, 2);
    System.out.println(list.removeN(0,2));
    list.removeN(0,2);
    list.removeN(7, 4);
    list.removeN(6,3);

    System.out.println(list);
  }
}