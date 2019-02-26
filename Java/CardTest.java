// Program to test your Card class

public class CardTest {

	public static void main(String[] args) {

		Card test = new Card(0,0);  // Ace of Spades (suit is 0, rank is 0)
		
		
		if (!test.getSuit().equals("Spades")) {
			System.out.println("Fail test #3");
		}
		
		if (!test.getRank().equals("Ace")) {
			System.out.println("Fail test #4");
		}
		
		if (!test.toString().equals("Ace of Spades")) {
			System.out.println("Fail test #5");
		}
		
		if (test.getDeeptiValue() != 28) {
			System.out.println("Fail test #6");
		}


		
		// IMPORTANT!!
		// it is highly recommended that you add more code
		// here to more fully test your Card class.
		
		
		System.out.println("Done testing.");
	}

}
