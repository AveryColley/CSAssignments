// Avery Colley
// Practice Problem 06

public class LinkedList {

    private Node head;
    private int size;

    public LinkedList() {
        head = null;
        size = 0;
    }

    public void add(int element) {
        Node newNode = new Node(element);

        if (head == null) {
            head = newNode;
            size = 1;
        } else {
            Node current = head;
            while (current.getNext() != null) {
                current = current.getNext();
            }
            current.setNext(newNode);
            size++;
        }
    }

    public int getSize() {
        return size;
    }

    public boolean removeN(int element, int parameter) {
        int check = 0;
        if(head == null) {
            return false;
        } else {
            Node current = head;
            while(current != null) {
                if(current.getElement() == element) {
                    check++;
                }
                current = current.getNext();
            }
            if(check >= parameter) {
                for(int i = 0; i < parameter; i++) {
                    this.removeElement(element);
                }
                size = size - parameter;
                return true;
            } else {
                return false;
            }
        }
    }

    private void removeElement(int element) {
        if(head == null) {}
        else if(head.getElement() == element) {
            head = head.getNext();
        } else {
            Node current = head.getNext();
            Node previous = head;
            while(current != null) {
                if (current.getElement() == element) {
                    previous.setNext(current.getNext());
                    return;
                } else {
                    current = current.getNext();
                    previous = previous.getNext();
                }
            }
        }
    }

    @Override
    public String toString() {
        String s = "";
        if (head == null) {
            return s;
        } else {
            Node current = head;
            while (current.getNext() != null) {
                s += current.toString() + ", ";
                current = current.getNext();
            }
            s += current.toString(); // last item has no trailing comma
            return s;
        }
    }

}
