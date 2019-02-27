// File name: Maze.cpp
// Author: CS201 Instructor
// userid: 
// Email: 
// Class: C201 @ Vanderbilt U.
// Assignment Number: 
// Description:  Class implementation that represents a maze. 
//    A maze has walls, open locations, a start location, and an end location.
//    The initial maze is read from a file. See problem spec for file format.
//    The user can get a location from the maze, and keep track of which locations
//    have been visited. Locations are represented by x-y coordinates or Point objects.
//    The origin (0,0) is the lower left corner of the graph; the x-coordinate moves
//    left to right across the x axis; the y-coordinate moves bottom to top up the y axis.
//    The set() method is private, as the maze should not be changed once it has been
//    read from the file.
// Last Changed:  3-24-2010


#include <stdexcept>
#include <cstdlib>
#include "Maze.h"

// Constructor
// Accepts file name as a parameter
// Reads the file and initializes start and end location and Maze Matrix and visited matrix
Maze::Maze (std::string filename)
{

    std::string str;

    std::ifstream file(filename.c_str());
    // Do error checking here
    if (!file) {
        std::cout << "Unable to open file. Press enter to exit program.";
        getline(std::cin, str);  // consume existing line
        std::cin.get();  // get the key press
        exit(1);
    }

    Point doesNotExist(-1,-1);
    startLocation = doesNotExist;
    endLocation = doesNotExist;

    // file starts with number of rows & cols; read them in
    file >> numRows;
    file >> numCols;
    getline(file, str);  // consume rest of first line

    if (numRows<0 || numRows>MAX_ROWS || numCols<0 || numCols>MAX_COLS) {
        std::cout << "File contains invalid size specification for the Maze. "
                  << "Press enter to exit program.";
        getline(std::cin, str);  // consume rest of existing line
        std::cin.get();  // get the key press
        exit(1);
    }


    int y=numRows-1;
    while( getline(file, str) )
    {
        if (str.length()!=(size_t)numCols) {
            std::cout << "File contained a line with incorrect number of characters"
                      << std::endl;
            std::cout << "Ignoring this line: " << str << std::endl;
            std::cout << "Row = " << y << std::endl;
            continue;
        }


        // Initialize the maze matrix and boolean visited flag matrix
        for(int x=0;x<numCols;x++)
        {
            char ch = str.at(x);
            set(ch,x,y);
            visited[x][y] = false;
            if(ch==START)  // if this is the start...
            {
                Point start(x,y);
                startLocation = start;
            }
            else if(ch==END)   // if this is the end...
            {
                Point end(x,y);
                endLocation = end;
            }

        }
        y--;
        if(y<0)
            break;
    }
    if (y != -1) {
        std::cout << "File did not contain the correct number of rows." << std::endl;
        std::cout << "Unpreditable results may occur." << std::endl;
    }

    file.close();

}





//printMaze
//Prints current maze to console
void Maze::printMaze() const
{
    std::cout << toString() << std::endl;
}

// printMazeVisited
// Prints current maze to console with visited locations marked by a 'V'
void Maze::printVisitedMaze() const
{
    std::cout << toStringVisited() << std::endl;
}


// toString
// convert Maze to a string representation
std::string Maze::toString() const
{
    std::string result;
    for(int y=numRows-1;y>=0;y--)
    {
        for(int x=0;x<numCols;x++)
        {
            result += mazeMatrix[x][y];
        }
        result += '\n';
    }

    return result;
}

// toStringVisited
// convert visited Maze to a string representation with visited locations marked by a 'V'
std::string Maze::toStringVisited() const
{
    std::string result;
    for(int y=numRows-1;y>=0;y--)
    {
        for(int x=0;x<numCols;x++)
        {
            if (isOpen(x,y) && hasBeenVisited(x,y))
            {
                result += 'V';
            }
            else
            {
                result += mazeMatrix[x][y];
            }
        }
        result += '\n';
    }

    return result;
}

// Get the maze dimensions
int Maze::getNumRows() const
{
    return numRows;
}

int Maze::getNumCols() const
{
    return numCols;
}


// Private helper function to insure row & col are within the maze
void Maze::checkRange(int x, int y) const
{
    if(y<0 || y>=this->numRows || x<0 || x>=this->numCols)
    {
        throw std::range_error("Maze:: Index is out of range");
    }
}


// Set an item in the maze matrix at the given coodinates.
// Throws std::range_error if the coordinates are not within the maze bounds
void Maze::set (char new_item, int x, int y)
{
    checkRange(x, y);
    mazeMatrix[x][y] = new_item;
}

void Maze::set (char new_item, Point location)
{
    set(new_item, location.x, location.y);
}


// Get an item at the given coodinates from the maze matrix.  
// Throws std::range_error if the coordinates are not within the maze bounds
char Maze::get (int x, int y) const
{
    checkRange(x, y);
    return mazeMatrix[x][y];

}

char Maze::get (Point location) const
{
    return get(location.x, location.y);
}


// Set visited flag in the visited matrix at the given coodinates. 
// Throws std::range_error if the coordinates are not within the maze bounds
void Maze::markVisited (int x, int y)
{
    checkRange(x, y);
    visited[x][y] = true;
}

void Maze::markVisited (Point location)
{
    markVisited(location.x, location.y);
}

// Get visited flag at the given coodinates from the visited matrix.
// Throws std::range_error if the coordinates are not within the maze bounds
bool Maze::hasBeenVisited (int x, int y) const
{
    checkRange(x, y);
    return visited[x][y];
}

bool Maze::hasBeenVisited (Point location) const
{
    return hasBeenVisited(location.x, location.y);
}

// Determine if the given coodinates is an open location
// Throws std::range_error if the coordinates are not within the maze bounds
bool Maze::isOpen(int x, int y) const
{
    return !isWall(x,y);
}

bool Maze::isOpen(Point location) const
// Throws std::range_error if the coordinates are not within the maze bounds
{
    return isOpen(location.x, location.y);
}

// Determine if the given coodinates is a wall location
// Throws std::range_error if the coordinates are not within the maze bounds
bool Maze::isWall(int x, int y) const
{
    return (get(x,y)==WALL);
}

bool Maze::isWall(Point location) const
{
    return isWall(location.x, location.y);
}




//resetVisited
//Reset boolean visited Matrix
void Maze::resetVisitedFlags()
{
    for(int x=0;x<numCols;x++)
    {
        for(int y=0;y<numRows;y++)
        {
            visited[x][y]=false;
        }
    }

}

// Get the start and end locations
Point Maze::getStartLocation() const
{
    return startLocation;
}

Point Maze::getEndLocation() const
{
    return endLocation;
}
