package Week1Questions;
import java.util.Scanner;

public class Lab1Q3 {
    public static void main(String[] args) {
        Scanner scanner= new Scanner(System.in);
         int a= scanner.next().charAt(0) +5;
         int ascii7= a%2;
         int kalan7= a/2;
         
      
        int ascii6= kalan7%2;
        int kalan6= kalan7/2;
 
        int ascii5= kalan6%2;
        int kalan5= kalan6/2;

        int ascii4= kalan5%2;
        int kalan4= kalan5/2;

        int ascii3= kalan4%2;
        int kalan3= kalan4/2;

        int ascii2= kalan3%2;
        int kalan2= kalan3/2;

        int ascii1= kalan2%2;
        int kalan1= kalan2/2;

        int ascii0= kalan1%2;
        //int kalan0= kalan1/2;
         
        int yeni=ascii2*1 +ascii1*2+ascii0*4+ ascii4*8+ascii3*16+ascii7*32+ascii6*64+ascii5*128;

        System.out.println(yeni);
        scanner.close();
    }
    
}
