// File name: PointAgenda.h
// Author: 
// userid: 
// Email: 
// Class: 
// Assignment Number:
// Description:  Maintains an agenda of Points to be visited.  Contains functions
//     prototypes to add, remove, peek (retrieve next), and retrieve size of the 
//     agenda. THIS IS A VIRTUAL CLASS.
// Last Changed:  8-4-2009

#ifndef PointAgenda_H
#define PointAgenda_H

#include "Point.h"


class PointAgenda
{
public:
    // virtual Class Destructor
    virtual ~PointAgenda() {}

    // isEmpty (pure virtual)
    // Checks if the agenda is empty
    virtual bool isEmpty() const = 0;

    // add (pure virtual)
    // adds a Point to the agenda.
    virtual void add(const Point& item) = 0;

    // remove (pure virtual)
    // removes the next Point from the agenda.
    virtual void remove() = 0;

    // peek (pure virtual)
    // Returns the next Point from the agenda without removing it from the agenda.
    virtual Point peek() const = 0;

    // size (pure virtual)
    // Returns the number of Points in the agenda.
    virtual size_t size() const = 0;


};

#endif
