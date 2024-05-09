/* CMSC 430 Compiler Theory and Design
   Project 4 Skeleton
   UMGC CITE
   Summer 2023
   
   Project 4 Parser with semantic actions for static semantic errors

   Edited by Jade Pearl for Project 2, 3 & 4 in Spring 2024*/

%{
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
Types find(Symbols<Types>& table, CharPtr identifier, string tableName);
void yyerror(const char* message);

Symbols<Types> scalars;
Symbols<Types> lists;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER

%token <type> INT_LITERAL CHAR_LITERAL REAL_LITERAL HEX_LITERAL

%token ADDOP MULOP RELOP ANDOP ARROW REMOP EXPOP NEGOP OROP NOTOP

%token BEGIN_ CASE CHARACTER IF THEN ELSE ELSIF END ENDSWITCH FUNCTION INTEGER REAL IS LIST OF OTHERS RETURNS SWITCH WHEN LEFT RIGHT FOLD ENDFOLD ENDIF

%type <type> list expressions body type statement_ statement cases case expression
	term primary exponent elsifrecurs condition elsif list_choice

%%

function:	
	function_header optional_variable body ;
	
		
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ;

type:
	INTEGER {$$ = INT_TYPE; } |
	REAL {$$ = REAL_TYPE; }|
	CHARACTER {$$ = CHAR_TYPE; };
	
optional_variable:
	optional_variable variable |
	%empty ;
    
variable:	
	IDENTIFIER ':' type IS statement ';' {checkAssignment($3, $5, "Variable Initialization"); scalars.insert($1, $3);} |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $5);}{listVsElements($5, $7);} |
	error ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {checkList($1, $3);} | 
	expression ;

parameters:
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type |
	%empty ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	unary |
	expression |
	WHEN condition ',' expression ':' expression 
		{$$ = checkWhen($4, $6);} |
	IF condition THEN statement_ elsifrecurs ENDIF {$$ = ifStatement($2, $4, $5);} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH 
		{$$ = checkSwitch($2, $4, $7);} ; |
	FOLD direction operator list_choice ENDFOLD {checkFold($4);};

elsif:
	ELSIF condition THEN statement_ {$$ = $4;};

elsifrecurs:
	elsif elsifrecurs {$$ = $2;} | ELSE statement_ {$$ = $2;} |
	%empty;

cases:
	cases case {$$ = checkCases($1, $2);} |
	%empty {$$ = NONE;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $4;} |
	error ;

direction:
	LEFT | RIGHT ;

operator:
	ADDOP | MULOP ;

list_choice:
	list | IDENTIFIER ;

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
	expression RELOP expression {compareChars($1, $3);} ;
	
expression:
	expression ADDOP term {$$ = checkArithmetic($1, $3);} |
	term ;
      
term:
	term MULOP exponent {$$ = checkArithmetic($1, $3);} |
	term REMOP exponent {$$ = checkMod($1, $3);} |
	exponent ;

exponent:
	unary EXPOP exponent {checkUnaryExpo($3);} |
	unary ;

unary:
	NEGOP primary {handleUnaryNegation($2);}{checkUnaryExpo($2);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	HEX_LITERAL |
	IDENTIFIER '(' expression ')' {find(lists, $1, "List");}{checkSubscript($3);} |
	IDENTIFIER  {$$ = find(scalars, $1, "Scalar");} 

%%

Types find(Symbols<Types>& table, CharPtr identifier, string tableName) {
	Types type;
	if (!table.find(identifier, type)) {
		appendError(UNDECLARED, tableName + " " + identifier);
		return MISMATCH;
	}
	return type;
}

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
