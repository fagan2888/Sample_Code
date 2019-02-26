// File name: Queue_t.cpp
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: this is a template queue class that holds data of any specified type
// Last Changed: 11/10/2017


// Your job to fill in this file!

#include <cstddef>
#include <stdexcept>
#include <iostream>



// Class Constructor
// post: Queue is created & initialized to be empty
template <typename ItemType>
Queue<ItemType>::Queue():mySize(0), myFront(nullptr),myBack(nullptr)
{
}


// Copy Constructor
// pre:  Class object, aQueue, exists
// post: Object is initialized to be a copy of the parameter
template <typename ItemType>
Queue<ItemType>::Queue(const Queue<ItemType>& aQueue):mySize(aQueue.mySize),
                                           myFront(nullptr), myBack(nullptr)
{
    if(aQueue.myFront != nullptr){
        //copy the first Node
        myFront = new Node;
        myFront->val = aQueue.myFront->val;
        //copy the rest of the Nodes
        NodePtr newPtr=myFront;
        for (NodePtr origPtr=aQueue.myFront->next; origPtr!= nullptr;
             origPtr=origPtr->next){
            newPtr->next = new Node;
            newPtr = newPtr->next;
            newPtr->val = origPtr->val;
        }
        newPtr->next= nullptr;
        myBack = newPtr;
    }

}

// Class Destructor
// Destroys a queue
// pre:  Class object exists
// post: Class object does not exist
template <typename ItemType>
Queue<ItemType>::~Queue()
{
    while (!isEmpty()){
        this->dequeue();
    }
}

// Assignment operator
// Assigns a queue to another
// pre: both class objects exist
// post: this class object gets assigned a copy of the parameter class object
template <typename ItemType>
const Queue<ItemType>& Queue<ItemType>::operator= (const Queue<ItemType>& rhs)
{
    if(this != &rhs){   //check for self-assignment
        Queue<ItemType> tmp(rhs); //make a copy
        std::swap(myFront, tmp.myFront);
        std::swap(myBack, tmp.myBack);
        std::swap(mySize, tmp.mySize);
    }
    return *this;

}

// isEmpty
// Checks if the queue is empty
// pre:  A queue exists.
// post: Returns true if it IS empty, false if NOT empty.
template <typename ItemType>
bool Queue<ItemType>::isEmpty() const
{
    return  myFront==nullptr;
}

// enqueue
// enqueues an item to back of the queue.
// pre:  Queue exists and item is passed.
// post: adds the given item to the end of the queue.
template <typename ItemType>
void Queue<ItemType>::enqueue(const ItemType& item)
{
    NodePtr tmp=new Node;
    tmp->val = item;
    tmp->next = nullptr;
    if(isEmpty()){ // empty queue, update myFront and myBack
        myFront=tmp;
        myBack=tmp;
    }else{
        myBack->next=tmp;
        myBack=tmp;
    }
    mySize++;
}

// dequeue
// dequeues the front item off the queue
// pre:  Queue exists.
// post: Removes item on front of the queue. If the queue
//       was already empty, throws an std::underflow_error exception.
template <typename ItemType>
void Queue<ItemType>::dequeue()
{
    if(isEmpty()){
        throw std::underflow_error("The queue is empty");
    }else{
        NodePtr tmp=myFront;
        myFront=myFront->next;
        delete tmp;
        tmp=nullptr;
        mySize--;
    }
    if(mySize==0){
        myBack= nullptr;
    }

}

// front
// Returns the front item of the queue without dequeueing it.
// pre:  Queue exists.
// post: Returns item at front of queue.  If the queue is empty,
//       throws an std::underflow_error exception.
template <typename ItemType>
ItemType Queue<ItemType>::front() const
{
    if(isEmpty()){
        throw std::underflow_error("The queue is empty");
    }else{
        return myFront->val;
    }
}

// size
// Returns the number of items on the queue.
template <typename ItemType>
size_t Queue<ItemType>::size() const
{
    return mySize;
}

