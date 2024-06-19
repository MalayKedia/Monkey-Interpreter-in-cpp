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

%token LET INT_VAL FLT_VAL TRUE_VAL FALSE_VAL STR_ID LT GT LTEQ GTEQ EQ NEQ AND OR NOT ADD_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN
%token FUNC RETURN IF ELSE STR_VAL

%left OR
%left AND
%right NOT
%left '+' '-' 														// Left associative operators '+' and '-'
%left '*' '/' '^'														// Left associative operators '*' and '/'
%right Uminus 														// Right associative unary minus operator

%type <strptr> INT_VAL FLT_VAL STR_ID
%type <nodeptr> num_expression bool_expression
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
    | LET STR_ID '=' bool_expression ';'                    { ASTNode* node = new ASTNode(ASSIGNMENT, $2, NULL, $4); $$ = new Statement(DECLARATION, node); }
     
    | STR_ID '=' num_expression	';'						    { ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, $3); $$ = new Statement(REDEFINITION, node); }
    | STR_ID '=' bool_expression ';'						{ ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, $3); $$ = new Statement(REDEFINITION, node); }

    | STR_ID ADD_ASSIGN num_expression ';'				    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("PLUS"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID MINUS_ASSIGN num_expression ';'				{ ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("MINUS"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID MULT_ASSIGN num_expression ';'				    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("MULTIPLY"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
    | STR_ID DIV_ASSIGN num_expression ';'				    { ASTNode* new_val = new ASTNode(ARITHMETIC_OPERATOR, new string("DIVIDE"), new ASTNode(VARIABLE, $1), $3); ASTNode* node = new ASTNode(ASSIGNMENT, $1, NULL, new_val); $$ = new Statement(REDEFINITION, node); }
;

bool_expression
    : bool_expression AND bool_expression		            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("AND"), $1, $3); }
    | bool_expression OR bool_expression		            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("OR"), $1, $3); }
    | NOT bool_expression					                { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("NOT"), NULL, $2); }
    | num_expression LT num_expression			            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("LT"), $1, $3); }
    | num_expression GT num_expression			            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("GT"), $1, $3); }
    | num_expression EQ num_expression			            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("EQ"), $1, $3); }
    | num_expression NEQ num_expression			            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("NEQ"), $1, $3); }
    | num_expression LTEQ num_expression		            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("LTEQ"), $1, $3); }
    | num_expression GTEQ num_expression		            { $$ = new ASTNode(BOOLEAN_OPERATOR, new string("GTEQ"), $1, $3); }
    | TRUE_VAL									            { $$ = new ASTNode(BOOLEAN, new string("true")); }
    | FALSE_VAL									            { $$ = new ASTNode(BOOLEAN, new string("false")); }
    | STR_ID                                                { $$ = new ASTNode(VARIABLE, $1); }
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