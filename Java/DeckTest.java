// Program to test your Deck class

public class DeckTest {

	public static void main(String[] args) {

		Deck d = new Deck();

		if (d.isEmpty()) {
			System.out.println("Fail test #1");
		}

		if (d.numberOfCards()!= Deck.SIZE_OF_DECK) {
			System.out.println("Fail test #2");
		}
		
		Card c=null;
		
		for (int i=0; i<Deck.SIZE_OF_DECK; i++) {
			c = d.draw();
			System.out.println("Draw #" + (i+1) + ": " + c);
		}
		
		// the deck should now be empty
		if (!d.isEmpty()) {
			System.out.println("Fail test #3");
		}
		
		if (d.numberOfCards()!= 0) {
			System.out.println("Fail test #4");
		}
		
		// the deck should know which card we drew last (note: we are comparing references)
		if (c != d.getLastDraw()) {
			System.out.println("Fail test #4a");
		}
		
		// re-deal
		d.initialize();
		
		if (d.isEmpty()) {
			System.out.println("Fail test #5");
		}

		if (d.numberOfCards()!= Deck.SIZE_OF_DECK) {
			System.out.println("Fail test #6");
		}
		
		
		
		// IMPORTANT!!
		// it is highly recommended that you add more code
		// here to more fully test your Card class.
		
		
		System.out.println("\nDone testing.");
		
		
	}

}
