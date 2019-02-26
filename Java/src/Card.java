// Name: Shijie Shi
// VUnetID: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: CS1101, Vanderbilt University
// Honor statement: I have neither given nor received unauthorized help on this assignment
// Date: 07/02/2017

// Description: Represents a single playing card.


public class Card {
	
	// DO NOT CHANGE THESE TWO LINES OF CODE
	public static final String[] suits = { "Spades", "Hearts", "Clubs", "Diamond" };
	
	public static final String[] ranks = { "Ace", "2", "3", "4", "5", "6", "7",
	"8", "9", "10", "Jack", "Queen", "King" };

	private int suit;
	private int rank;

	//initiate a constructor for card class
	//precondition: the value of suit should between 0-3 inclusive
	//				the value of rank should between 0-12 inclusive
	public Card ( int newSuit, int newRank ) {
		if ( newSuit<0 || newSuit >3 ) {
			throw new IllegalArgumentException();
		}
		if ( newRank <0 || newRank>12 ) {
			throw new IllegalArgumentException();
		}
		suit = newSuit;
		rank = newRank;
	}

	/**
	 * getSuit--this method returns the suit of the Card as a String value
	 * @return String, value of the suit of the Card
	 */
	public String getSuit(){ return suits[suit]; }

	/**
	 * getRank-- this method returns the rank of the Card as a String value
	 * @return  String, rank of the Card
	 */
	public String getRank(){ return ranks[rank]; }


	/**
	 * toString-- this method returns a string that represents both the rank and suit of the card
	 * @return String, rank and suit of the card
	 */
	public String toString(){ return getRank() + " of " + getSuit(); }

	/**
	 * equals-- this method determines if two cards have the same rank and suit
	 * @param other an object (could be any kind of object)
	 * @return boolean, return true when two cards have the same suit and rank
	 */
	public boolean equals( Object other ) {
		if ( other instanceof Card ) {
			Card compareCard = (Card) other;
			return suit==compareCard.suit && rank==compareCard.rank;
		}else { //not a Card object
			return false;
		}
	}

	/**
	 * getDeeptiValue-- this method returns the Deepti Value of the card
	 * @return integer
	 */
	public int getDeeptiValue() {
		if ( suit==0 || suit==1 ) { //suit is Spades or Heart
			if( rank==0 ) { //rank is ace
				return 2*14;
			}else { //rank is not ace
				return 2*(rank+1);
			}
		}else {
			if ( rank==0 ) { //rank is ace
				return 14;
			} else { //rank is not ace
				return rank+1;
			}
		}
	}


}
