/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser 
   
   Edited by Jade Pearl for Project 2 in Spring 2024*/

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL REAL_LITERAL HEX_LITERAL

%token ADDOP MULOP ANDOP RELOP REMOP EXPOP NEGOP OROP NOTOP ARROW

%token BEGIN_ CASE CHARACTER IF THEN ELSE ELSIF END ENDSWITCH FUNCTION INTEGER REAL IS LIST OF 
	OTHERS RETURNS SWITCH WHEN LEFT RIGHT FOLD ENDFOLD ENDIF

%%

function:	
	function_header optional_variable body ;

function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ;

type:
	INTEGER | REAL | CHARACTER ;
	
optional_variable:
	optional_variable variable |
	%empty ;
    
variable:	
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' |
	error ;

list:
	'(' expressions ')' ;

parameters:
	parameters ',' parameter | 
	parameter ;

parameter:
	IDENTIFIER ':' type |
	%empty ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	unary |
	expression |
	WHEN condition ',' expression ':' expression |
	IF condition THEN statement_ elsifrecurs
		ELSE statement_ ENDIF ; |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH ; |
	FOLD direction operator list_choice ENDFOLD ;

elsif:
	ELSIF condition THEN statement_
	elsifrecurs ;

elsifrecurs:
	elsifrecurs elsif |
	%empty ;

cases:
	cases case |
	%empty ;
	
case:
	CASE INT_LITERAL ARROW statement ';' |
	error ;

direction:
	LEFT | RIGHT ;

operator:
	ADDOP | MULOP ;

list_choice:
	list | IDENTIFIER

condition:
	condition OROP and |
	and ;

and:
	and ANDOP not |
	not ;

not:
	NOTOP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression ;

expression:
	expression ADDOP term |
	term ;
      
term:
	term MULOP exponent |
	term REMOP exponent |
	exponent ;

exponent:
	unary EXPOP exponent |
	unary ;

unary:
	NEGOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL |
	CHAR_LITERAL |
	REAL_LITERAL |
	HEX_LITERAL |
	IDENTIFIER '(' expression ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
