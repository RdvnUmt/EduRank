package Week2Questions;

import java.util.Scanner;

public class Lab2Q1 {
    public static void main(String[] args) {
        Scanner scanner= new Scanner(System.in);

        double tax= scanner.nextDouble();
        double income=0;
        if (tax > 4500) { // Case where tax is above the 40000+ bracket
            income = 40000 + (tax - 4500) * 100 / 30;
        } else if (tax > 2500) { // Case where tax is in the 20001-40000 bracket
            income = 20000 + (tax - 2500) * 100 / 20;
        } else if (tax > 1000) { // Case where tax is in the 10001-20000 bracket
            income = 10000 + (tax - 1000) * 100 / 10;
        } else if (tax > 250) { // Case where tax is in the 5001-10000 bracket
            income = 5000 + (tax - 250) * 100 / 5;
        } 
        System.out.println(income);
        
        scanner.close(); 
    }
}
