// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// definitions for the evaluation functions

#include <vector>

typedef char* CharPtr;

enum Operators {ADD, SUBTRACT, MULTIPLY, DIVIDE, MOD, EXPONENT, UNARY, LESS, GREAT, EQUAL, 
NOTEQUAL, GEQUAL, LEQUAL, AND, OR, NOT, LEFTFOLD, RIGHTFOLD};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateRelational(double left, Operators operator_, double right);
double fold(bool direction, Operators operator_, vector<double>* vals);