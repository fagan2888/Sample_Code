// File name: LifoPointAgenda.h
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: Derive from the PointAgenda class via public inheritance
//              Keeping track of our agenda in last-in-first-out manner.
// Last Changed: 11/10/2017


#ifndef LifoPointAgenda_H
#define LifoPointAgenda_H

// Your job to fill in this file!
#include "PointAgenda.h"
#include "Stack_t.h"

class LifoPointAgenda : public PointAgenda
{
private:
    Stack<Point> lifoPoint;

public:
    // Checks if the agenda is empty
    virtual bool isEmpty() const {
        return lifoPoint.isEmpty();
    }

    // adds a Point to the agenda.
    virtual void add(const Point& item) {
        lifoPoint.push(item);
    }

    // removes the next Point from the agenda.
    virtual void remove() {
        lifoPoint.pop();
    }

    // Returns the next Point from the agenda without removing it from the agenda.
    virtual Point peek() const {
        return lifoPoint.top();
    }

    // Returns the number of Points in the agenda.
    virtual size_t size() const {
        return lifoPoint.size();
    }
};


#endif


