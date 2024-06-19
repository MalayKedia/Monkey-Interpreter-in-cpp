%{
    #include "pic.cc"
    extern "C" void yyerror(const char *s);
    extern int yylex(void);
	
    vector<Statement> stmt_list; // List of all statements in the program
%}

%union{
    string operator;
    ASTnode* node;
    int ival;
    double fval;
}

%token INT_VAL FLT_VAL LET STR_ID

%left '+' '-' 														// Left associative operators '+' and '-'
%left '*' '/' 														// Left associative operators '*' and '/'
%right Uminus 														// Right associative unary minus operator

%type <ival> INT_VAL
%type <fval> FLT_VAL
%type <operator> arithmetic_operator
%type <node> num_expression

%start program 														// Starting rule for the grammar
%%

/* GRAMMAR */

program
	:	stmt_list															// A program consists of a list of statements
;

stmt_list
	:	stmt_list stmt												// A statement list can be another statement list followed by a statement
	|	stmt																	// Or just a single statement
;

stmt
	: LET STR_ID '=' num_expression										// Assignment statement
	/* | expression ';'													// Expression statement: just evaluate the expression and print its value */
;



num_expression
	: num_expression arithmetic_operator num_expression		{ $$ = new ASTnode(ARITHMETIC_OPERATOR, *$2, $1, $3); delete $2; }	
	| '-' num_expression %prec Uminus		                { $$ = new ASTnode(UMINUS, $2); }
	| INT_VAL									            { $$ = new ASTnode(INT, $1);}
	| FLT_VAL									            { $$ = new ASTnode(FLOAT, $1); }
;

arithmetic_operator
    : '+' { $$ = new string('+'); }
    | '-' { $$ = new string('-'); }
    | '*' { $$ = new string('*'); }
    | '^' { $$ = new string('^'); }

%%

/* ADDITIONAL C CODE */

int main() { 
  yyparse();
  return 0;
}