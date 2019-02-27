// File name: Main.cpp
// Author: CS201 Instructor
// userid: 
// Email: 
// Class: C201 @ Vanderbilt U.
// Assignment Number: 
// Description:  Determine if a maze has a solution (and print a trace).
//    A basic exercise for stacks and queues (or any agenda-type container).
// Last Changed:  3-24-2010


#include <iostream>
#include <algorithm>
#include "Maze.h"
#include "PointAgenda.h"
#include "LifoPointAgenda.h"
#include "FifoPointAgenda.h"
#include "MazeSolver.h"


// chooseAgenda() function
// Prompts the user for the desired agenda type,
// instantiates such an agenda via new, and returns it.
PointAgenda* chooseAgenda();



int main()
{
    std::string choice;
    std::string filename;

    std::cout << "MAZE SOLVER!!\n" << std::endl;

    do
    {
        std::cout << "Please enter name of file containing the maze: ";
        std::cin >> filename;
        Maze newMaze(filename);
        std::cout << "Here is the maze to be solved:\n" << newMaze.toString()
                  << std::endl;

        PointAgenda* myAgenda = chooseAgenda();

        MazeSolver solver(newMaze, *myAgenda);

        std::cout << "\nDo you want to trace the execution of the solver? (Y|N)"
                  << std::endl;
        std::cin >> choice;
        std::cout << std::endl;
        bool trace = choice.at(0)=='Y' || choice.at(0)=='y';

        solver.solve(trace);

        delete myAgenda;

        std::cout << "\nDo you want to solve another maze? (Y|N)" << std::endl;
        std::cin >> choice;
    }while(choice.at(0)=='Y' || choice.at(0)=='y');
    return 0;
}


// chooseAgenda() function
// Prompts the user for the desired agenda type,
// instantiates such an agenda via new, and returns it.
PointAgenda* chooseAgenda()
{
    int choice = 0;
    do {
        std::cout << "\nPlease select the type of agenda you want to use "
                  << "by entering its number:"
                  << std::endl;
        std::cout << "1: Stack-based agenda" << std::endl;
        std::cout << "2: Queue-based agenda" << std::endl;
        std::cout << "Enter choice: ";
        std::cin >> choice;
        if (choice<1 || choice>2)
        {
            std::cout << "Invalid choice. Try again." << std::endl;
        }
    } while ((choice<1 || choice>2) & std::cin.good());

    switch (choice)
    {
        case 1:
            std::cout << "\nSolving the maze with a stack-based agenda:" << std::endl;
            return new LifoPointAgenda;
        case 2:
            std::cout << "\nSolving the maze with a queue-based agenda:" << std::endl;
            return new FifoPointAgenda;
        default:
            std::cout << "Non-int input. Halting program." << std::endl;
            exit(1);
    }
}

