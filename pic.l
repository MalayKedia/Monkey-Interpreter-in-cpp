%{
    #include "pic.hh"
    #include "parse.tab.h"
    using namespace std;
%}

/* DEFINITIONS */

/* yywrap handles the end-of-input logic, if noyywrap is used, program exits on end-of-file (EOF) */
%option noyywrap

digit                       [0-9]
fraction                    ([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)
ws                          [ \t\n]*
letter                      [a-zA-Z]
letter_                     [a-zA-Z_]

/* RULES */

%%

let                          { return LET; }
func                         { return FUNC; }
return                       { return RETURN; }

true                         { return TRUE_VAL; }
false                        { return FALSE_VAL; }

if                           { return IF; }
else                         { return ELSE; }

;                            { return SEMICOLON; }

,                            { return COMMA; }
:                            { return COLON; }

\+                           { return PLUS; }
\-                           { return MINUS; }
\*                           { return MULT; }
\/                           { return DIV; }
\^                           { return POW; }  /* I am using ^ for power, if it is inconsistent with your testcases, do tell */

=                            { return ASSIGN; }
\+=                          { return ADD_ASSIGN; }
\-=                          { return MINUS_ASSIGN; }
\*=                          { return MULT_ASSIGN; }
\/=                          { return DIV_ASSIGN; }

\<                           { return LT; }
\>                           { return GT; }
==                           { return EQ; }
\<=                          { return LTEQ; }
\>=                          { return GTEQ; }
!=                           { return NEQ; }

&&                           { return AND; }
\|\|                         { return OR; }
!                            { return NOT; }

\(                           { return LPAREN; }
\)                           { return RPAREN; }
\{                           { return LBRACE; }
\}                           { return RBRACE; }
\[                           { return LBRACKET; }
\]                           { return RBRACKET; }

{digit}+                     { yylval.ival = atoi(yytext); return INT_VAL; }
{fraction}                   { yylval.name = atof(yytext); return FLT_VAL; }

{letter_}({letter_}|{digit})* { yylval.strptr = new string(yytext); return STR_ID; }
({letter_}|{digit})+          { yylval.strptr = new string(yytext); return STR_VAL; }

{ws}                         ; /* Ignore spaces */

.                            { fprintf(stderr, "unknown_token: %d\n", yytext[0]); exit(1); }

%%

int yywrap() {
    return 1;
}
