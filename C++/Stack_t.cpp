// File name: Stack_t.cpp
// Author: Shijie Shi
// userid: shis2
// Email: shijie.shi@vanderbilt.edu
// Class: 01
// Assignment Number: 07
// Honor Statement: I have neither given nor received unauthorized aid in completing this work.
// Description: This class provide support for a template stack abstraction that
//              holds data of any specific type.
// Last Changed: 11/10/2017


// Your job to fill in this file!

#include <cstddef>
#include <stdexcept>
#include <iostream>

// Class Constructor
// post: stack is created & initialized to be empty
template <typename ItemType>
Stack<ItemType>::Stack():stackSize(0), myHead(nullptr)
{
}


// Copy Constructor
// pre: parameter object, rhs, exists
// post: stack is created to be a copy of the parameter stack
template <typename ItemType>
Stack<ItemType>::Stack(const Stack<ItemType>& rhs):stackSize(rhs.size()),myHead(nullptr)
{
    if(rhs.myHead != nullptr){
        //copy the first Node
        myHead = new Node;
        myHead->val = rhs.myHead->val;
        //copy the rest of the Nodes
        NodePtr newPtr=myHead;
        for (NodePtr origPtr=rhs.myHead->next; origPtr!= nullptr;
             origPtr=origPtr->next){
            newPtr->next = new Node;
            newPtr = newPtr->next;
            newPtr->val = origPtr->val;
        }
        newPtr->next= nullptr;
    }
}



// Class Deconstructor
// pre: the stack exists
// post: the stack is destroyed and any dynamic memory is returned to the system
template <typename ItemType>
Stack<ItemType>::~Stack()
{
    while(!isEmpty()){
        pop();
    }
}


// Assignment operator
// Assigns a stack to another
// pre: both class objects exist
// post: this class object gets assigned a copy of the parameter class object
template <typename ItemType>
const Stack<ItemType> & Stack<ItemType>::operator= (const Stack<ItemType>& rhs)
{
    if(this != &rhs){   //check for self-assignment
        Stack<ItemType> tmp(rhs); //make a copy
        std::swap(myHead, tmp.myHead);
        std::swap(stackSize, tmp.stackSize);
    }
    return *this;
}


// isEmpty
// Checks if the stack is empty
// pre:  A stack exists.
// post: Returns true if it IS empty, false if NOT empty.
template <typename ItemType>
bool Stack<ItemType>::isEmpty() const
{
    return  myHead==nullptr;
}


// push
// Pushes an item on top of the stack.
// pre:  Stack exists and item is passed.
// post: the item is placed on top of the stack, and size is incremented.
template <typename ItemType>
void Stack<ItemType>::push(const ItemType& item)
{
    NodePtr tmp=new Node;
    tmp->val = item;
    if (myHead==nullptr){
        tmp->next= nullptr;
        myHead=tmp;
    }else{
        tmp->next=myHead;
        myHead=tmp;
    }
    stackSize++;
}


// pop
// Pops the top item off the stack.
// pre:  Stack exists.
// post: Removes item on top of stack.  If the stack
//       was already empty, throws a std::underflow_error exception.
template <typename ItemType>
void Stack<ItemType>::pop()
{
    if(isEmpty()){
        throw std::underflow_error("The stack is empty");
    }else{
        NodePtr tmp=myHead;
        myHead=myHead->next;
        delete tmp;
        tmp=nullptr;
        stackSize--;
    }

}


// top
// Returns the top item of the stack without popping it.
// pre:  Stack exists.
// post: Returns item on top of stack.  If the stack
//       was already empty, throws a std::underflow_error exception.
template <typename ItemType>
ItemType Stack<ItemType>::top() const
{
    if(isEmpty()){
        throw std::underflow_error("The stack is empty");
    }else {
        return myHead->val;
    }
}


// size
// Returns the number of items on the stack.
// post: Returns size from the private section of class.
template <typename ItemType>
size_t Stack<ItemType>::size() const
{
    return stackSize;
}
