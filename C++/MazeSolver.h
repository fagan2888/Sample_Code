// File name: MazeSolver.h
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: explore a maze from a given start position until the ending position is found
// Last Changed: 11/10/2017


#ifndef MAZESOLVER_H
#define MAZESOLVER_H

// Your job to fill in this file!

#include "Maze.h"
#include "PointAgenda.h"
#include "Point.h"

class MazeSolver
{
private:
	Maze& maze;
	PointAgenda& agenda;

	//Checks to see if given point is a valid point:
    //          within the boundary, not a wall, and hasn't been visited
	//pre: Point object and Maze object exist
	bool isValid(Point curPoint, const Maze& curMaze);

public:
	//Class Constructor
	//pre: Maze object and PointAgenda object exist
	//post: Maze object and Point Agenda object are stored into private reference variables
    //      The private variables are reference variables to avoid making copies of
    //      the parameters.
	MazeSolver(Maze& newMaze, PointAgenda& newAgenda);

	//This method returns true is the maze is solvable.
    // And List all Points as they are visited and print a total count of visited Points.
    bool solve(bool trace);
};


#endif /* ifndef */