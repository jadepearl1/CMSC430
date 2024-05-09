/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   UMGC CITE
   Summer 2023
   
   Project 3 Parser with semantic actions for the interpreter 
   
   Last edited by Jade Pearl on 4/22/2024 */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

double* globalParameters;
int totalParameters = 0;
int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);
vector<double>* extract_list(CharPtr list_name);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL HEX_LITERAL

%token <oper> ADDOP MULOP ANDOP RELOP REMOP EXPOP NEGOP OROP NOTOP

%token ARROW

%token BEGIN_ CASE CHARACTER IF THEN ELSE ELSIF END ENDSWITCH FUNCTION INTEGER REAL IS LIST OF OTHERS RETURNS SWITCH WHEN LEFT RIGHT FOLD ENDFOLD ENDIF

%type <value> body statement_ statement cases case expression term primary
	 condition relation or exponent unary not elsifrecurs elsif parameter direction

%type <list> list expressions list_choice

%%

function:	
	function_header optional_variable  body ';' {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ;

type:
	INTEGER |
	REAL |
	CHARACTER ;
	
optional_variable:
	optional_variable variable |
	%empty ;
	
variable:	
	IDENTIFIER ':' type IS statement ';' {scalars.insert($1, $5);}; |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $7);} |
	error ;

list:
	'(' expressions ')' {$$ = $2;} ;

parameters:
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type {scalars.insert($1, globalParameters[totalParameters++]);} |
	%empty ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} | 
	expression {$$ = new vector<double>(); $$->push_back($1);}

body:
	BEGIN_ statement_ END {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	unary |
	expression |
	WHEN condition ',' expression ':' expression {$$ = $2 ? $4 : $6;} |
	IF condition THEN statement_ elsif ENDIF {$$ = $2 ? $4 : $5;}|
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH
		{$$ = !isnan($4) ? $4 : $7;} |
	FOLD direction operator list_choice ENDFOLD {$$ = fold($2, $<oper>3, $4);}

elsif:
	ELSIF condition THEN statement_ elsif {$$ = $2 ? $4 : $5;} |
	elsifrecurs ;

elsifrecurs:
	ELSE statement_ {$$ = $2;}| %empty {$$ = NAN;};

cases:
	cases case {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;} |
	error ;

direction:
	LEFT {$$ = true;} | RIGHT {$$ = false;}

operator:
	ADDOP | MULOP ;

list_choice: 
	list | IDENTIFIER {$$ = extract_list($1);};

condition:
	condition ANDOP or {$$ = $1 && $2;} |
	or ;

or:
	or OROP not {$$ = $1 || $2;} |
	not ;

not:
	NOTOP relation {$$ = !$1;} | 
	relation ;

relation:
	'(' condition ')' {$$ = $2;} |
	expression RELOP expression {$$ = evaluateRelational($1, $2, $3);} ;

expression:
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;
      
term:
	term MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);}  |
	term REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
	unary EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} | 
	unary ;

unary:
	NEGOP primary {$$ = evaluateArithmetic($2, $1, 0);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	HEX_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

vector<double>* extract_list(CharPtr list_name) {
	vector<double>* list;
	if(lists.find(list_name, list))
		return list;
	appendError(UNDECLARED, list_name);
	return list;
}

int main(int argc, char *argv[]) {
    firstLine();
	globalParameters = new double[argc - 1];
    // Convert command line arguments to doubles and store in global array
    for (int i = 1; i < argc; ++i) {
        globalParameters[i - 1] = atof(argv[i]);
	}
    yyparse();
    if (lastLine() == 0)
        cout << "Result = " << result << endl;
    delete[] globalParameters; // Free allocated memory
    return 0;
}