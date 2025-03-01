package Bil331_calisma;

public class Problem2 {
    public static int maxDifference(int[] A, int p, int r) {
        // Eğer dizide yalnızca bir eleman varsa geçerli bir fark yoktur.
        if (p >= r) {
            return Integer.MIN_VALUE;
        }

        // İki eleman varsa, tek bir fark hesaplanır.
        if (r == p + 1) {
            return A[r] - A[p];
        }

        // Diziyi iki yarıya bölüyoruz.
        int m = (p + r) / 2;

        // Sol ve sağ yarılar için rekürsif olarak maksimum farkı hesapla.
        int diffLeft = maxDifference(A, p, m);
        int diffRight = maxDifference(A, m + 1, r);
        int crossDiff = maxBetweenHalves(A, p, m, r);

        // Üç değerden en büyüğünü döndür.
        return Math.max(crossDiff, Math.max(diffLeft, diffRight));
    }

    private static int maxBetweenHalves(int[] A, int p, int m, int r) {
        // "Cross" fark: sol yarıdaki minimum değeri ve sağ yarıdaki maksimum değeri
        // bul.
        int minLeft = A[p];
        for (int i = p + 1; i <= m; i++) {
            if (A[i] < minLeft) {
                minLeft = A[i];
            }
        }

        int maxRight = A[m + 1];
        for (int j = m + 2; j <= r; j++) {
            if (A[j] > maxRight) {
                maxRight = A[j];
            }
        }
        return maxRight - minLeft;
    }

    public static void main(String[] args) {
        // Örnek dizi. Dikkat: Java'da diziler 0-indeksli olduğundan A[0] ... A[n-1]
        // şeklinde düşünülür.
        int[] A = { 2, 3, 10, 6, 4, 8, 1 };

        // maxDifference fonksiyonu, dizinin tüm elemanlarını kapsayacak şekilde
        // çağrılır.
        int result = maxDifference(A, 0, A.length - 1);
        System.out.println("Maksimum fark (A[j] - A[i] ve i < j): " + result);
    }
}
