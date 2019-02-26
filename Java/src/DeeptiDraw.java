//Name: CS101 instructor
//VUnetid:
//Email:
//Honor statement: 
//Class: CS101, Vanderbilt University
//Date: 

// Description: The "Deepti Draw" Card Game

public class DeeptiDraw {

	public static final int DEEPTI_DRAW_MAX = 3;

	public static void main(String[] args) {

		// Initialize a deck of cards
		Deck deck = new Deck();

		// Initialize two Players
		Player p1 = new Player("Lisa");
		Player p2 = new Player("Pete");

		// Keep track of number of turns
		int turn = 1;
		// Play till one of the players scores 100 or more
		do {
			System.out.println("\nTurn " + turn);
			// each Player draws from the deck
			int curScoreP1 = takeOneTurn(p1, deck);
			int curScoreP2 = takeOneTurn(p2, deck);

			// Whoever has more face value for current deal will score equal to
			// the difference
			if (curScoreP1 > curScoreP2) {
				scoreOneTurn(p1,curScoreP1, curScoreP2);
			} else if (curScoreP2 > curScoreP1) {
				scoreOneTurn(p2,curScoreP1, curScoreP2);
			} else {
				System.out.println("Thus this turn is a draw!");
			}
			
			System.out.println("Current scores:: " + p1 + " has: "
					+ p1.getScore() + "   " + p2 + " has: " + p2.getScore());
			turn++;
		} while (p1.getScore() < 100 && p2.getScore() < 100);

		// Check to see who won
		if (p1.getScore() >= 100) {
			report(p1);
		} else {
			report(p2);
		}

	}

	// let a player take a turn drawing a card from the deck.
	// return the value of their card.
	public static int takeOneTurn(Player p, Deck deck) {
		int origCount = deck.numberOfCards();
		Card drawCard = p.takeTurn(deck);
		int newCount = deck.numberOfCards();
		
		if (origCount - newCount > DEEPTI_DRAW_MAX) {
			System.out.print("\n\n" + p + " is a cheater!! ");
			System.out.println("Took more than " + DEEPTI_DRAW_MAX + " cards.");
			System.out.println("Stopping the game!");
			System.exit(1);
		}
		
		if (drawCard != deck.getLastDraw()) {   // comparing references
			System.out.print("\n\n" + p + " is a cheater!! ");
			System.out.println("Did not keep the last card drawn from the deck.");
			System.out.println("Stopping the game!");
			System.exit(1);
		}
		
		System.out.print(p + " drew a " + drawCard);
		int curScore = drawCard.getDeeptiValue();
		System.out.println(" and has " + curScore + " for this deal");
		return curScore;
	}
	
	
	// add to a player's score for one turn
	public static void scoreOneTurn(Player p, int score1, int score2) {
		int oldScore = p.getScore();
		int points = Math.abs(score1-score2);
		System.out.println("Thus " + p + " scores " + points + " for this turn");
		p.increaseScore(points);
		int newScore = p.getScore();
		
		if (points != (newScore-oldScore)) {
			System.out.print("\n\n" + p + " is a cheater!! ");
			System.out.println("Added more points to score than allotted.");
			System.out.println("Stopping the game!");
			System.exit(1);
		}
		
	}
		
	// report the final winner
	public static void report(Player p) {
		System.out.println("\n\nWinner is " + p + " with score of "
				+ p.getScore());

	}

}