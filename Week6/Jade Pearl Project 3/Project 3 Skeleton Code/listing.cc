// CMSC 430 Compiler Theory and Design
// Project 1 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the functions that produces the 
// compilation listing

/* Jade Pearl
Project 1 for CMSC 430 Compiler Theory and Design
Spring 2024: March 23, 2024
I added the functionlity to count and display all the different types
of errors picked up by the compiler

Edited a small issue for Project 2*/

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error= "";
static int totalErrors = 0;
static int totalLexical = 0;
static int totalSyntactic = 0;
static int totalSemantic = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	
	//Display the error summary
	if (totalErrors > 0) {
		printf("\nLexical errors %d", totalLexical);
		printf("\nSyntax errors %d", totalSyntactic);
		printf("\nSemantic errors %d", totalSemantic);
	} else {
		printf("Compiled Successfully\n");
	}
	printf("\n");
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };

	switch (errorCategory)
	{
		case LEXICAL:
			totalLexical++;
			break;
		case SYNTAX:
			totalSyntactic++;
			break;
		case GENERAL_SEMANTIC:
			totalSemantic++;
			break;
		default:
			break;
	}

	error += messages[errorCategory] + message + "\n";
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s", error.c_str());
	error = "";
}
