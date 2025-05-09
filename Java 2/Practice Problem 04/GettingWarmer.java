// Avery Colley
// Practice Problem 04

import javax.swing.*;

class GettingWarmer extends JFrame {

   public GettingWarmer() {
      JPanel root = new JPanel();
      JLabel cTemp = new JLabel("Celsius");
      JLabel fTemp = new JLabel("Fahrenheit");
      JTextField fInput = new JTextField("<Temp in F>");
      JTextField cOutput = new JTextField("<Temp in C>");
      JButton goButton = new JButton("Convert");

      goButton.addActionListener(e -> {
         double c;
         double f;
         try {
            f = Double.parseDouble(fInput.getText());
            c = (f - 32) * (5.0/9.0);
            c = Math.round(c * 100) / 100.0;
            cOutput.setText("" + c);
         } catch(Exception err) {
            cOutput.setText("<ERROR>");
         }
      });

      root.add(fTemp);
      root.add(fInput);
      root.add(cTemp);
      root.add(cOutput);
      root.add(goButton);

      this.getContentPane().add(root);
      this.setTitle("Temperature Converter");
      this.setSize(400, 300);
      this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      this.setVisible(true);
   }










   public static void main(String[] args) {
      new GettingWarmer();
   }

}