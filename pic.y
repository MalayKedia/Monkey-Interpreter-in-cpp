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

%token INT_VAL FLT_VAL LET STR_ID
%token FUNC RETURN IF ELSE TRUE_VAL FALSE_VAL ADD_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN LTEQ GTEQ EQ NEQ AND OR NOT STR_VAL

%left '+' '-' 														// Left associative operators '+' and '-'
%left '*' '/' 														// Left associative operators '*' and '/'
%right Uminus 														// Right associative unary minus operator

%type <strptr> INT_VAL FLT_VAL STR_ID
%type <nodeptr> num_expression
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
	: LET STR_ID '=' num_expression ';'                     { ASTNode* node = new ASTNode(ASSIGNMENT, $2, NULL, $4); $$ = new Statement(DECLARATION, node); }       
    | STR_ID '=' num_expression	';'						    { ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, $3); $$ = new Statement(REDEFINITION, node); }
;

num_expression
	: num_expression '+' num_expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("PLUS"), $1, $3); }	
    | num_expression '-' num_expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("MINUS"), $1, $3); }
    | num_expression '*' num_expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("MULTIPLY"), $1, $3); }
    | num_expression '/' num_expression		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string("DIVIDE"), $1, $3); }
	| '-' num_expression %prec Uminus		                { $$ = new ASTNode(ARITHMETIC_OPERATOR, new string ("UMINUS") , NULL, $2 ); }
	| INT_VAL									            { $$ = new ASTNode(INT, $1);}
	| FLT_VAL									            { $$ = new ASTNode(FLOAT, $1); }
    | STR_ID                                                { $$ = new ASTNode(VARIABLE, $1); }
;

%%

/* ADDITIONAL C CODE */

int main() { 
  yyparse();
  return 0;
}