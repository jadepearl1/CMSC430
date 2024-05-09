/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

int hexToInt(const char*);
int charToAscii(const char*);

%}

%option noyywrap

ws		[ \t\r]+
comment		"//".*\n|\-\-.*\n
line		[\n]
id		[A-Za-z]([A-Za-z0-9]*(_{1,2}[A-Za-z0-9])?)*
digit		[0-9]
dec		{digit}+
hexadec     [0-9A-Fa-f]+
hex      #{hexadec}+
real     {digit}*\.{digit}+([eE]?[\-\+]?{digit}+)?
char		'.'|'\\b'|'\\t'|'\\n'|'\\r'|'\\f'
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"      { ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"      { ECHO; yylval.oper = DIVIDE; return(MULOP); }
"%"      { ECHO; yylval.oper = MOD; return(REMOP); }
"^"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
"~"		{ ECHO; yylval.oper = UNARY; return(NEGOP); }
"&"		{ ECHO; yylval.oper = AND; return(ANDOP); }
"|"		{ ECHO; yylval.oper = OR; return(OROP); }
"!"		{ ECHO; yylval.oper = NOT; return(NOTOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREAT; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"<>"		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GEQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LEQUAL; return(RELOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
if		{ ECHO; return(IF); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
then		{ ECHO; return(THEN); }
real		{ ECHO; yylval.value = atof(yytext); return(REAL); }
left		{ ECHO; return(LEFT); }
right		{ ECHO; return(RIGHT); }
fold		{ECHO; return(FOLD); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endfold		{ ECHO; return(ENDFOLD); }
endif		{ ECHO; return(ENDIF); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{dec}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{real}		{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{hex}	{ ECHO; yylval.value = hexToInt(yytext); return(HEX_LITERAL); }
{char}		{ ECHO; yylval.value = charToAscii(yytext); return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%

int hexToInt(const char* hexString) {
   return strtol(hexString + 1, 0, 16);
}

int charToAscii(const char* charLiteral) {
    if (charLiteral[1] == '\\') {
        switch (charLiteral[2]) {
            case '\'': return '\'';
            case '"': return '"';
            case '\\': return '\\';
            case 'n': return '\n';
            case 't': return '\t';
            case 'r': return '\r';
            case 'b': return '\b';
            case 'f': return '\f';
            default: return charLiteral[2];
        }
    } else {
        return charLiteral[1]; // Return the ASCII value
    }
}