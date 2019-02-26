// File name: Stack_t.h
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: This class provide support for a template stack abstraction that
//              holds data of any specific type.
// Last Changed: 11/10/2017



#ifndef STACK_T_H
#define STACK_T_H

#include <cstdio>

// Your job to fill in this file!
template <typename  ItemType>
class Stack
{
private:
    // TO DO -- it is your job to define the private part of the class
    struct Node{
        ItemType val;
        Node *next;

    };

    typedef Node *NodePtr;

    size_t stackSize;
    NodePtr myHead;

public:
    // Class Constructor
    // post: stack is created & initialized to be empty
    Stack();

    // Copy Constructor
    // pre: parameter object, rhs, exists
    // post: stack is created to be a copy of the parameter stack
    Stack(const Stack<ItemType>& rhs);

    // Class Deconstructor
    // pre: the stack exists
    // post: the stack is destroyed and any dynamic memory is returned to the system
    ~Stack();

    // Assignment operator
    // Assigns a stack to another
    // pre: both class objects exist
    // post: this class object gets assigned a copy of the parameter class object
    const Stack<ItemType>& operator= (const Stack<ItemType>& rhs);

    // isEmpty
    // Checks if the stack is empty
    // pre:  A stack exists.
    // post: Returns true if it IS empty, false if NOT empty.
    bool isEmpty() const;

    // push
    // Pushes an item on top of the stack.
    // pre:  Stack exists and item is passed.
    // post: the item is placed on top of the stack, and size is incremented.
    void push(const ItemType& item);

    // pop
    // Pops the top item off the stack.
    // pre:  Stack exists.
    // post: Removes item on top of stack.  If the stack
    //       was already empty, throws a std::underflow_error exception.
    void pop();

    // top
    // Returns the top item of the stack without popping it.
    // pre:  Stack exists.
    // post: Returns item on top of stack.  If the stack
    //       was already empty, throws a std::underflow_error exception.
    ItemType top() const;

    // size
    // Returns the number of items on the stack.
    // post: Returns size from the private section of class.
    size_t size() const;

};


#include "Stack_t.cpp"
#endif
