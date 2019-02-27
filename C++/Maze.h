// File name: Maze.h
// Author: CS201 Instructor
// userid: 
// Email: 
// Class: C201 @ Vanderbilt U.
// Assignment Number: 
// Description:  Class that represents a maze. 
//    A maze has walls, open locations, a start location, and an end location.
//    The initial maze is read from a file. See problem spec for file format.
//    The user can get a location from the maze, and keep track of which locations
//    have been visited. Locations are represented by x-y coordinates or Point objects.
//    The origin (0,0) is the lower left corner of the graph; the x-coordinate moves
//    left to right across the x axis; the y-coordinate moves bottom to top up the y axis.
//    The set() method is private, as the maze should not be changed once it has been
//    read from the file.
// Last Changed:  3-24-2010


#ifndef MAZE_H
#define MAZE_H

#include <string>
#include <fstream>
#include <iostream>
#include "Point.h"

const char WALL='#';
const char OPEN=' ';
const char START='o';
const char END='*';
const int MAX_ROWS = 50;
const int MAX_COLS = 50;

class Maze
{
public:
	// Constructor
	// Accepts file name as a parameter
	// Reads the file and initializes start and end location and Maze Matrix and visited matrix
	Maze (std::string filename);



	// printMaze
	// Prints current maze to console
	void printMaze() const;

	// printMazeVisited
	// Prints current maze to console with visited locations marked by a 'V'
	void printVisitedMaze() const;

	// toString
	// convert Maze to a string representation
	std::string toString() const;

	// toStringVisited
	// convert visited Maze to a string representation with visited locations marked by a 'V'
	std::string toStringVisited() const;

	// Get the maze dimensions
	int getNumRows() const;
	int getNumCols() const;

	// Get an item at the given coodinates from the maze matrix.
	// Throws std::range_error if the coordinates are not within the maze bounds
	char get (int x, int y) const;
	char get (Point location) const;

	// Set visited flag in the visited matrix at the given coodinates.
	// Throws std::range_error if the coordinates are not within the maze bounds
	void markVisited (int x, int y);
	void markVisited (Point location);

	// Get visited flag at the given coodinates from the visited matrix.
	// Throws std::range_error if the coordinates are not within the maze bounds
	bool hasBeenVisited (int x, int y) const;
	bool hasBeenVisited (Point location) const;

	// Determine if the given coodinates is an open location
	// Throws std::range_error if the coordinates are not within the maze bounds
	bool isOpen(int x, int y) const;
	bool isOpen(Point location) const;

	// Determine if the given coodinates is a wall location
	// Throws std::range_error if the coordinates are not within the maze bounds
	bool isWall(int x, int y) const;
	bool isWall(Point location) const;

	//reset the Visited matrix
	void resetVisitedFlags();

	// Get the start and end locations
	Point getStartLocation() const;
	Point getEndLocation() const;


private:

	// height and width of the maze
	int numRows;
	int numCols;

	// Maze's matrix storage buffer.  Using static arrays -- Big 3 not required
	char mazeMatrix[MAX_COLS][MAX_ROWS];
	bool visited[MAX_COLS][MAX_ROWS];

	// Start & end locations for maze
	// Point (-1, -1) indicates the maze has no start/end location
	Point startLocation;
	Point endLocation;

	// Set an item in the maze matrix at the given coodinates.
	// Throws std::range_error if the coordinates are not within the maze bounds
	// These are private since no one outside the class should be changing the maze
	void set (char new_item, int x, int y);
	void set (char new_item, Point location);

	// Private helper function to insure x & y are within the maze
	void checkRange(int x, int y) const;


};
#endif /* ifndef */
