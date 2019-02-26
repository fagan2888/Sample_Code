// Name: Shijie Shi
// VUnetID: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: CS1101, Vanderbilt University
// Honor statement: I have neither given nor received unauthorized help on this assignment
// Date: 07/02/2017

// Description: Deck of cards.

import java.util.Random;

public class Deck {

	public static final int SIZE_OF_DECK = Card.suits.length * Card.ranks.length; //52
	
	private Card[] deck;
	private int numOfCards;
	private Card lastCard;

	//This is the constructor for the Deck class
	public Deck() {
		deck = new Card[SIZE_OF_DECK];
        initialize();
		lastCard = null;

	}

	/**
	 * initialize-- creates a Card object for each card in the deck
	 */
	public void initialize() {
		int number =0;
		for ( int i=0; i<=3; i++ ) {
			for ( int j=0; j<=12; j++ ) {
				deck[ number ] = new Card(i,j);
				number++;
			}
		}
		numOfCards = SIZE_OF_DECK;
	}

	/**
	 * isEmpty-- this method tells if the deck is empty
	 * @return boolean, returns true when the deck is empty
	 */
	public boolean isEmpty() {
		for ( int i=0; i<SIZE_OF_DECK; i++) {
			if( deck[i]!=null || numOfCards!=0 ) {
				return false;
			}
		}
		return true;
	}

	/**
	 * numberOfCards-- this method will report the number of cards still remaining in the deck
	 * @return integer, the number of cards remaining in the deck
	 */
	public int numberOfCards() {
		int numberOfLeftCards = 0;
		for ( int i=0; i<SIZE_OF_DECK; i++) {
			if ( deck[i] != null ) {
				numberOfLeftCards++;
			}
		}
		return numberOfLeftCards;
	}

	/**
	 * draw-- picks a random card from those remaining in the deck, and return it to the caller
	 * @return Object Card, the card drawn from the remaining deck
	 */
	public Card draw() {
		if ( isEmpty() ) {
			initialize();
		}
		//pick a random number from the number of rest cards
		int randomCardIndex = (int) ( Math.random()*numOfCards );
		//assign the random picked card to the lastCard
		lastCard = deck[randomCardIndex];
		//swap the random picked card with the last non-null card in the deck
		deck[randomCardIndex] = deck[ numOfCards-1 ];
		//set the random picked to null (remove it from the deck)
		deck[ numOfCards-1 ] = null;
		//decrement number of cards left in the deck
		numOfCards--;
		//return the random picked card to the caller
		return lastCard;
	}

	/**
	 * getLastDraw-- this method returns the last card drawn from the deck
	 * @return Object Card, returns the last card drawn from the deck
	 */
	public Card getLastDraw() {
		return lastCard;
	}

}
