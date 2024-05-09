// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, REAL_TYPE, CHAR_TYPE, NONE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkList(Types left, Types right);
void listVsElements(Types elems, Types list);
void checkSubscript(Types right);
Types compareChars(Types left, Types right);
Types checkWhen(Types true_, Types false_);
Types checkSwitch(Types case_, Types when, Types other);
Types checkCases(Types left, Types right);
Types checkArithmetic(Types left, Types right);
void checkUnaryExpo(Types num);
Types handleUnaryNegation(Types operand);
Types checkMod(Types left, Types right);
Types ifStatement(Types left, Types elsif, Types els);
void checkFold(Types list);