// CMSC 430 Compiler Theory and Design
// Project 1 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the function prototypes for the functions that produce
// the compilation listing

/*Jade Pearl
Project 1 for CMSC 430 Compiler Theory and Design
Spring 2024 March 20, 2024.
I did not alter this file*/

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

