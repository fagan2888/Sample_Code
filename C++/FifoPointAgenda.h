// File name: FifoPointAgenda.h
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: Derive from the PointAgenda class via public inheritance.
//              Keeping track of our agenda in first-in-first-out manner.
// Last Changed: 11/10/2017


#ifndef FifoPointAgenda_H
#define FifoPointAgenda_H

// Your job to fill in this file!

#include "PointAgenda.h"
#include "Queue_t.h"

class FifoPointAgenda : public PointAgenda
{
private:
    Queue<Point> fifoPoint;

public:
    // Checks if the agenda is empty
    virtual bool isEmpty() const {
        return fifoPoint.isEmpty();
    }

    // adds a Point to the agenda
    virtual void add(const Point& item) {
        fifoPoint.enqueue(item);
    }

    // removes the next Point from the agenda
    virtual void remove() {
        fifoPoint.dequeue();
    }

    // Returns the next Point from the agenda without removing it from the agenda
    virtual Point peek() const {
        return fifoPoint.front();
    }

    // Returns the number of Points in the agenda
    virtual size_t size() const {
        return fifoPoint.size();
    }
};



#endif

