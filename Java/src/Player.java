// Name: Shijie Shi
// VUnetID: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: CS1101, Vanderbilt University
// Honor statement: I have neither given nor received unauthorized help on this assignment
// Date: 07/02/2017

// Description: Card Player.

public class Player {
    private String name;
    private Card lastDraw;
    private int score;

    //constructor
    public Player(String newName) { name=newName; }

    /**
     * getLastDraw-- this method returns the last card drawn
     * @return Object Card, the last card drawn
     */
    public Card getLastDraw() { return lastDraw; }

    /**
     * getScore-- this method returns the Player's current score
     * @return integer, the Player's current score
     */
    public int getScore() { return score; }

    /**
     * resetScore-- this method sets the Player's current score to zero
     */
    public void resetScore() { score=0; }

    /**
     * increaseScore-- adds the integer value received as a parameter to the Player's current score
     * @param newPoints a integer value received from the caller
     */
    public void increaseScore(int newPoints) { score=score+newPoints; }

    /**
     * toString-- this method returns Player's name
     * @return String, player's name
     */
    public String toString() { return name; }

    /**
     * takeTurn-- this method takes a turn for the player in the game of Deepti Draw
     * @param deckOfCards Object Deck received from the caller
     * @return Object Card, the current card that player drawn from the deck
     */
    public Card takeTurn(Deck deckOfCards) {
        Card currentCard = deckOfCards.draw();
        int drawTime=1;
        int currentCardValue=currentCard.getDeeptiValue();
        while ( drawTime<DeeptiDraw.DEEPTI_DRAW_MAX  && currentCardValue<=14 ){
            currentCard = deckOfCards.draw();
            drawTime++;
        }
        lastDraw=currentCard;
        return currentCard;
    }
}
