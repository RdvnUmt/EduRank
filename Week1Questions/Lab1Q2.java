package Week1Questions;
import java.util.Scanner;

public class Lab1Q2 {
    public static void main(String[] args) {
        Scanner scanner= new Scanner(System.in);
        String character= scanner.nextLine();
        String word= scanner.nextLine();
        char firstLetter=(char) (word.charAt(0) - 32);
        String rest=word.substring(1,word.length()-1) + character;
        System.out.println(firstLetter+rest);
        scanner.close();
    }
}
