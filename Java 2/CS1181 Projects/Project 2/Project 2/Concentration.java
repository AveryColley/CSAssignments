// Avery Colley
// Project 2
// Concentration class creates the game concentration (or memory)
// Where the task is the flip over all the same cards

import javax.swing.*;
import java.awt.*;
import java.util.*;

public class Concentration extends JFrame {

   // SIZE determines the size of the palying field, this variable takes values 2, 4, 6, 8, 10
   // and adjustst the size of the field to contain 4, 16, 36, 64, 100 cards
   private final int SIZE = 4;

   private Deck d;
   private Random r;
   private Card card1;
   private Card card2;
   private int button1;
   private int button2;
   private int points;

   // Amount of comparisons between 2 cards made
   private int moves;

   // Creates the Concentration game window, allowing you to play the game
   public Concentration() {
      this.d = new Deck();
      this.r = new Random();
      JPanel root = new JPanel();
      JOptionPane.showMessageDialog(new JFrame(), "Welcome to concentration, in order to " +
         "play, click on the cards. Successfully matching two of the cards removes them from play. " +
         "this is a harder version of concentration where you can only see one card at a time, good luck!");
      GridLayout field = new GridLayout(SIZE, SIZE);
      root.setLayout(field);
      ArrayList<Card> cards = this.cardSample(this.d);
      ArrayList<JButton> buttons = new ArrayList<>();
      for(int i = 0; i < SIZE * SIZE; i++) {
         final int random = (SIZE * SIZE) - i;
         final int index = i;
         JButton a = new JButton();
         a.setIcon(new ImageIcon("Cards/back.png"));
         root.add(a);
         buttons.add(a);
         final Card c = cards.remove(r.nextInt(random));
         final ImageIcon j = new ImageIcon("Cards/" + c.getImageName());
         // Once a card is clicked it flips over and allows the player to select another card to see if they match
         a.addActionListener(e -> {
            a.setIcon(j);
            this.card2 = this.card1;
            this.card1 = c;
            this.button2 = this.button1;
            this.button1 = index;
            playGame(buttons);
         });
      }

      this.setSize(100 * SIZE, 100 * SIZE);
      this.setVisible(true);
      this.getContentPane().add(root);
      this.setTitle("Concentration");
      this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

   }

   // Returns and ArrayList of Card objects taken randomly from a given Deck
   // Each card is added twice so that there is a duplicate card to match with
   public ArrayList<Card> cardSample(Deck d) {
      ArrayList<Card> sample = new ArrayList<>();
      for(int i = 0; i < ((SIZE / 2) * SIZE); i++) {
         int removal = r.nextInt(52 - i);
         Card newCard = d.removeCard(removal);
         sample.add(newCard);
         sample.add(newCard);
      }
      return sample;
   }

   // Checks to see if two clicked cards are equal, if they are both cards remain
   // flipped and the game proceeds as normal. If the cards are not the same they both get flipped over to the back.
   // Once all cards are flipped over, displays a congratulatory message with the total amount of moves made
   public void playGame(ArrayList<JButton> list) {
      if(card1 != null && card2 != null && button1 != button2) {
         if(!card1.equalsTo(card2)) {
            list.get(button1).setIcon(new ImageIcon("Cards/back.png"));
            list.get(button2).setIcon(new ImageIcon("Cards/back.png"));
         } else {
            points++;
            list.get(button1).setEnabled(false);
            list.get(button2).setEnabled(false);
            if(points == (SIZE * SIZE) / 2) {
               moves++;
               JOptionPane.showMessageDialog(new JFrame(), "Congratualtions! You won in " + moves + " moves!");
            }
         }
         moves++;
         card1 = null;
         card2 = null;
      }
   }

   // Creates the Concentration window so the game can be played
   public static void main(String[] args) {
      new Concentration();
   }
}

