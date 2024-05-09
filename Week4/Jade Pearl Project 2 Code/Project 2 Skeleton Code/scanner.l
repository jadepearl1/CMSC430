/* Jade Pearl
Project 1 for CMSC 430 compiler Theory and Design
Spring 2024: March 20, 2024 
The code description is below which was already provided. I added tokens and their
rules to this file

updated an issue in Spring 2024 to use for Project 2*/

/* CMSC 430 Compiler Theory and Design
   Project 1 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		"//".*\n|\-\-.*\n
line		[\n]
id		[A-Za-z]([A-Za-z0-9]*(_{1,2}[A-Za-z0-9])?)*
digit		[0-9]
dec		{digit}+
hexadec		[0-9A-Fa-f]
hex		#{hexadec}+
real	{digit}*\.{digit}+([eE]?[\-\+]?{digit}+)?
char		'.'|'\\b'|'\\t'|'\\n'|'\\r'|'\\f'
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; return(ADDOP); }
"-"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"%"		{ ECHO; return(REMOP); }
"^"		{ ECHO; return(EXPOP); }
"~"		{ ECHO; return(NEGOP); }
"&"		{ ECHO; return(ANDOP); }
"|"		{ ECHO; return(OROP); }
"!"		{ ECHO; return(NOTOP); }
"<"		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"<>"		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
if		{ ECHO; return(IF); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
then		{ ECHO; return(THEN); }
real		{ ECHO; return(REAL); }
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

{id}		{ ECHO; return(IDENTIFIER);}
{dec}		{ ECHO; return(INT_LITERAL); }
{real}		{ ECHO; return(REAL_LITERAL); }
{hex}	{ ECHO; return(HEX_LITERAL); }
{char}		{ ECHO; return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%