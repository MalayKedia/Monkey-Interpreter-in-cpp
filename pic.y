%{
    #include "pic.cc"
    extern "C" void yyerror(const char *s);
    extern int yylex(void);
	
    vector<Statement*>* program_statement_list; // List of all statements in the program
%}

%union{
    ASTNode* nodeptr;
    string* strptr;
    Statement* statementptr;
    vector<Statement*>* stmtlistptr;
}

%token LET INT_VAL FLT_VAL TRUE_VAL FALSE_VAL STR_ID LT GT LTEQ GTEQ EQ NEQ AND OR NOT ADD_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN POW_ASSIGN
%token FUNC RETURN IF ELSE STR_VAL

%left OR
%left AND
%left EQ NEQ
%left LT GT LTEQ GTEQ
%left '+' '-' 														// Left associative operators '+' and '-'
%left '*' '/'   													// Left associative operators '*' and '/'
%right '^' 														    // Right associative operator '^'
%right NOT 														    // Right associative unary not operator
%right Uminus 														// Right associative unary minus operator

%type <strptr> INT_VAL FLT_VAL STR_ID STR_VAL
%type <nodeptr> expression
%type <statementptr> stmt
%type <stmtlistptr> stmt_list

%start program 														// Starting rule for the grammar
%%

/* GRAMMAR */

program
	:	stmt_list			                            { program_statement_list = $1; }												// A program consists of a list of statements
;

stmt_list
	:	stmt_list stmt									{ $1->push_back($2); $$ = $1; }
	|	stmt											{ $$ = new vector<Statement*>; $$->push_back($1); }
;

stmt
	: LET STR_ID '=' expression ';'                 { ASTNode* node = new ASTNode(ASSIGNMENT, $2, NULL, $4); $$ = new Statement(DECLARATION, node); }  
    | STR_ID '=' expression ';'			    		{ ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, $3); $$ = new Statement(REDEFINITION, node); }

    | STR_ID ADD_ASSIGN expression ';'			    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("PLUS"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID MINUS_ASSIGN expression ';'			{ ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("MINUS"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID MULT_ASSIGN expression ';'			    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("MULTIPLY"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID DIV_ASSIGN expression ';'			    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("DIVIDE"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID POW_ASSIGN expression ';'				{ ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("POWER"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
;

expression
    : TRUE_VAL					   	                { $$ = new ASTNode(BOOLEAN, new string("true")); }
    | FALSE_VAL							            { $$ = new ASTNode(BOOLEAN, new string("false")); }
    | expression AND expression		                { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("AND"), $1, $3); }
    | expression OR expression		                { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("OR"), $1, $3); }
    | NOT expression %prec NOT			            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("NOT"), NULL, $2); }
/* These 3 are supposed to be exclusive operators for booleans */
    | expression LT expression			            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("LT"), $1, $3); }
    | expression GT expression			            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("GT"), $1, $3); }
    | expression EQ expression			            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("EQ"), $1, $3); }
    | expression NEQ expression			            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("NEQ"), $1, $3); }
    | expression LTEQ expression		            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("LTEQ"), $1, $3); }
    | expression GTEQ expression		            { $$ = new ASTNode(COMPARISION_OPERATOR, new string("GTEQ"), $1, $3); }
/* These 6 are supposed to only compare 2 numbers (ints or floats) */
    | INT_VAL									    { $$ = new ASTNode(INT, $1);}
	| FLT_VAL									    { $$ = new ASTNode(FLOAT, $1); }
	| expression '+' expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("PLUS"), $1, $3); }	
    | expression '-' expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("MINUS"), $1, $3); }
    | expression '*' expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("MULTIPLY"), $1, $3); }
    | expression '/' expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("DIVIDE"), $1, $3); }
    | expression '^' expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("POWER"), $1, $3); }
	| '-' expression %prec Uminus		            { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string ("UMINUS"), NULL, $2 ); }
/* The above 6 have 4 exclusive operators for numbers with + also valid between 2 strings and * between a string and a int */
    | '(' expression ')'					        { $$ = $2; }
    | STR_ID                                        { $$ = new ASTNode(VARIABLE, $1); }
/* These 2 can hold either boolean, string or numbers */
    | STR_VAL                                       { $$ = new ASTNode(STRING, $1); }
;

%%

/* ADDITIONAL C CODE */

int main() { 
  yyparse();
  printProgram(program_statement_list);
  return 0;
}