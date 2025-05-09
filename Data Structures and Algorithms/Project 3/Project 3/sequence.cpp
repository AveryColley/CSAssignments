/*
    Avery Colley
    Project #3 - Linked Sequence Data Structure

    This file contains all of the functions for the Sequence class
*/

#include "sequence.h"

// Constructor: Craetes a Sequence object of the given length
Sequence::Sequence(size_type sz)
{
    // Creating an empty Sequence
    if(sz == 0) {
        head = nullptr;
        tail = nullptr;
    // Creating a non-empty Sequence
    } else {
        head = new SequenceNode();
        tail = head;
        SequenceNode * current = head;
        for(unsigned int i = 1; i < sz; i++) {
            current->next = new SequenceNode();
            current->next->prev = current;
            current = current->next;
            tail = current;
        }
    }
    numElts = sz;
}

// Copy Constructor: Creates and returns a deep copy of the given Sequence s
Sequence::Sequence(const Sequence& s)
{
    *this = s;
}

// Destructor: Deletes all nodes in the Sequence
Sequence::~Sequence()
{
    clear();
}

// Operator =: Sets a Sequence to be equal to the given Sequence s
Sequence& Sequence::operator=(const Sequence& s)
{
    // Handling empty Sequence
    if(s.size() == 0) {
        head = nullptr;
        tail = nullptr;
        numElts = 0;
    } else {
        head = s.head;
        SequenceNode* current = head;
        tail = current;
        numElts = 1;
        for(unsigned int i = 1; i < s.size(); i++) {
            current = current->next;
            push_back(current->elt);
        }
    }
    return *this;
}

// Operator []: Returns a reference to the value in the given position of the Sequence
// Throws an exception if the given position is outside the bounds of the Sequence
Sequence::value_type& Sequence::operator[](size_type position)
{
    // Don't allow access outside of the bounds of the Sequence
    if(position >= numElts) {
        throw exception();
    }
    SequenceNode* current;
    // If given position is closer to the front of the list start at head and go forwards
    if(position <= numElts / 2) {
        current = head;
        for(unsigned int i = 0; i < position; i++) {
            current = current->next;
        }
    // If given position is closer to the end of the list start at tail and go backwards
    } else {
        current = tail;
        for(unsigned int i = 1; i < numElts - position; i++) {
            current = current->prev;
        }
    }
    return current->elt;
}

// push_back: Takes a given value and appends it to the end of the list in it's own Node
void Sequence::push_back(const value_type& value)
{
    // Handling empty Sequence
    if(numElts == 0) {
        SequenceNode* newNode = new SequenceNode(value);
        head = newNode;
        tail = newNode;
    } else {
        SequenceNode* newNode = new SequenceNode(value);
        tail->next = newNode;
        newNode->prev = tail;
        tail = newNode;
    }
    numElts++;
}

// pop_back: Removes the last value in the Sequence
// Throws and exception if the Sequence is empty
void Sequence::pop_back()
{
    // Can't remove something from nothing
    if(numElts == 0) {
        throw exception();
    // Handling a sequence with head = tail
    } else if(numElts == 1) {
        delete tail;
        tail = nullptr;
        head = nullptr;
    } else {
        tail = tail->prev;
        delete tail->next;
        tail->next = nullptr;
    }
    numElts--;
}

// insert: inserts a new item into the Sequence with the given value at the given index
// Throws an exception if attempting to add an item past the bounds of the Sequence
void Sequence::insert(size_type position, value_type value)
{
    // Not allowing to add past the bounds
    if(position >= numElts) {
        throw exception();
    }
    SequenceNode* current;
    // If given position is closer to the front of the list start at head and go forwards
    if(position <= numElts / 2) {
        current = head;
        for(unsigned int i = 0; i < position; i++) {
            current = current->next;
        }
    // If given position is closer to the back of the list start at tail and go backwards
    } else {
        current = tail;
        for(unsigned int i = 1; i < numElts - position; i++) {
            current = current->prev;
        }
    }
    SequenceNode* newNode = new SequenceNode(value);
    // Adding to the front of the list
    if(position == 0) {
        head = newNode;
    } else {
        newNode->prev = current->prev;
        current->prev->next = newNode;
    }
    current->prev = newNode;
    newNode->next = current;
    numElts++;
}

// front: Returns the value in the front of the Sequence
// Throws an exception if the Sequence is empty
const Sequence::value_type& Sequence::front() const
{
    // Handling empty Sequence
    if(numElts == 0) {
        throw exception();
    } else {
        return head->elt;
    }
}

// back: Returns the value at the back of the Sequence
// Throws an exception if the Sequence is empty
const Sequence::value_type& Sequence::back() const
{
    // Handling empty Sequence
    if(numElts == 0) {
        throw exception();
    } else {
        return tail->elt;
    }
}

// empty: Returns true if the Sequence has no elements, and false otherwise
bool Sequence::empty() const
{
    return numElts == 0;
}

// size: Returns the amount of elements in the Sequence
Sequence::size_type Sequence::size() const
{
    return numElts;
}

// clear: Deletes every node in the Sequence
void Sequence::clear()
{
    SequenceNode* current = head;
    // while(current != nullptr)
    while(current) {
        SequenceNode* forDeletion = current->next;
        delete current;
        current = forDeletion;
    }
    numElts = 0;
}

// erase: Deletes count number of elements starting at the given position
// Throws an exception if trying to erase an element outside of the bounds of the Sequence
void Sequence::erase(size_type position, size_type count)
{
    // Don't allow earsing ourside of the bounds of the Sequence
    if(position + count >= numElts) {
        throw exception();
    }
    // If given position is closer to the front of the list start at head and go forwards
    SequenceNode* current;
    if(position <= numElts / 2) {
        current = head;
        for(unsigned int i = 0; i < position; i++) {
            current = current->next;
        }
    // If given position is closer to the back of the list start at tail and go backwards
    } else {
        current = tail;
        for(unsigned int i = 0; i < numElts - position; i++) {
            current = current->prev;
        }
    }
    SequenceNode* deleteThis = current;
    for(unsigned int i = 0; i < count; i++) {
        current = current->next;
        delete deleteThis;
        deleteThis = current;
    }
    numElts -= count;
}

// print: prints out the Sequence in the form <elt1, elt2, elt3, ... , eltN>
void Sequence::print(ostream& os) const
{
    SequenceNode* current = head;
    os << "<" << current->elt;
    current = current->next;
    while(current) {
        os << ", " << current->elt;
        current = current->next;
    }
    os << ">";
}

// Don't modify, do the output in the print() method
ostream& operator<<(ostream& os, const Sequence& s)
{
    s.print(os);
    return os;
}
