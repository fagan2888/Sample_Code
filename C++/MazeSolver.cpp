// File name: MazeSolver.cpp
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: explore a maze from a given start position until the ending position is found
// Last Changed: 11/10/2017


// Your job to fill in this file!


#include <iostream>
#include "MazeSolver.h"
#include "Maze.h"
#include "PointAgenda.h"

//Class Constructor
//pre: Maze object and PointAgenda object exist
//post: Maze object and Point Agenda object are stored into private reference variables
//      The private variables are reference variables to avoid making copies of
//      the parameters.
MazeSolver::MazeSolver(Maze& newMaze, PointAgenda& newAgenda) : maze(newMaze), agenda(newAgenda)
{
}

//This method returns true is the maze is solvable.
// And List all Points as they are visited and print a total count of visited Points.
bool MazeSolver::solve(bool trace) {

    trace= false;

    Point end = maze.getEndLocation();
    Point cur = maze.getStartLocation();
    size_t visited = 0;

    agenda.add(cur);
    std::cout << cur << "->";
    maze.markVisited(cur);
    visited++;

    while (cur != end && !agenda.isEmpty())
    {
        cur = agenda.peek();
        if (maze.hasBeenVisited(cur)) {
            agenda.remove();
            Point up(cur.x, cur.y + 1);
            if (isValid(up, maze)) {
                agenda.add(up);
            }
            Point down(cur.x, cur.y - 1);
            if (isValid(down, maze)) {
                agenda.add(down);
            }
            Point left(cur.x - 1, cur.y);
            if (isValid(left, maze)) {
                agenda.add(left);
            }
            Point right(cur.x + 1, cur.y);
            if (isValid(right, maze)) {
                agenda.add(right);
            }
        } else {
            std::cout << cur << "->";
            maze.markVisited(cur);
            visited++;
        }
    }
    if (cur == end) {
        std::cout << "Solution found!" << std::endl;
    }
    else {
        std::cout << "Solution NOT found!" << std::endl;
    }
    std::cout << "Number of nodes visited: " << visited << std::endl;
    return cur == end;
}

//Checks to see if given point is a valid point:
//          within the boundary, not a wall, and hasn't been visited
//pre: Point object and Maze object exist
bool MazeSolver::isValid(Point curPoint, const Maze& curMaze) {
    bool valid = false;
    if (curPoint.x >= 0 && curPoint.x <= curMaze.getNumCols() - 1 && 
             curPoint.y >= 0 && curPoint.y <= curMaze.getNumRows() - 1 ) {
        if (curMaze.isOpen(curPoint) && !curMaze.hasBeenVisited(curPoint)) {
            valid = true;
        }
    }
    return valid;
}