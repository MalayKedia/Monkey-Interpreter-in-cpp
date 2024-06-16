%{
	#include "pic.hh"
	#include "parse.tab.h"
	using namespace std;

    int current_indent = 0 ;
    int last_indent = 0 ;
%}

/* DEFINITIONS */

/* yywrap handles the end-of-input logic, if noyywrap is used, program exits on end-of-file (EOF) */
%option noyywrap 

digit                       [0-9]
fraction                    ([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)
ws							[ \t\n]*
letter                      [a-zA-Z_]

indent 						(  )

/* RULES */
%%
^(indent)*      {
                    current_indent = yyleng / 2;
                    if (current_indent == last_indent + 1) {
                        return INDENT_START;
                    } else {
                        int i=last_indent;
                        while (current_indent < i) {
                            i--;
                            return INDENT_END;
                        }
                    }
                }

"\- "            { current_indent++; return DASH; }
": "             { return COLON; }

true			{ return TRUE_EL; }
false			{ return FALSE_EL; }
null			{ return NULL_EL; }
-?{digit}+		{ yylval.int_val = atoi(yytext); return INT_EL; }
-?{fraction}	{ yylval.flt_val = atof(yytext); return FLT_EL; }
\"[^:\-\n]*\"   { yylval.str_ptr = new string(yytext + 1, strlen(yytext) - 2); return STR_EL; }

\n              { last_indent=current_indent; current_indent = 0; return NEWLINE; }

.         		{ fprintf(stderr, "unknown_token: %d\n", yytext[0]); exit(1); }
