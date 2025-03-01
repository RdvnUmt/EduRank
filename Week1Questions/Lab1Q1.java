package Week1Questions;
public class Lab1Q1 {
    public static void main(String[] args) {
        int input=10010708;

        char c1 = (char) (input / 1000000 + 96) ;
        char c2 = (char) ((input / 10000) % 100 + 96);
        char c3 = (char) ((input % 10000) / 100 + 96) ;
        char c4 = (char) ((input % 100) +96);

        
        System.out.print(c1);
        System.out.print(c2);
        System.out.print(c3);
        System.out.print(c4);
    }
}