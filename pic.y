%{
    #include "pic.cc"
    using namespace std;

    extern "C" void yyerror(const char *s);
    extern int yylex(void);

    YAMLmap* root_map=NULL;
    YAMLsequence* root_seq=NULL;
%}

%token INDENT_START INDENT_END DASH COLON NEWLINE STR_EL INT_EL FLT_EL TRUE_EL FALSE_EL NULL_EL

%union {
    YAMLelement *element_ptr;
    YAMLsequence *sequence_ptr;
    YAMLmap *map_ptr;
    string *str_ptr;
    int int_val;
    float flt_val;
}
%type <element_ptr> element
%type <sequence_ptr> sequence
%type <map_ptr> map
%type <str_ptr> STR_EL
%type <int_val> INT_EL
%type <flt_val> FLT_EL

%start program

%%
/* GRAMMAR */

program
    : sequence                          { root_seq = $1; }
    | map                               { root_map = $1; }
;

sequence
    : DASH element NEWLINE              { $$ = new YAMLsequence; $$->elements.push_back($2); }
    | sequence DASH element NEWLINE     { $1->elements.push_back($3); $$ = $1; }
;

map
    : STR_EL COLON element NEWLINE      { $$ = new YAMLmap; $$->elements.insert(make_pair($1, $3)); }
    | map STR_EL COLON element NEWLINE  { $1->elements.insert(make_pair($2, $4)); $$ = $1; }
;

element
    : STR_EL                            { $$ = new YAMLelement; $$->element_type = YAML_STRING; $$->element_value = $1; }
    | INT_EL                            { $$ = new YAMLelement; $$->element_type = YAML_INT; $$->element_value = new int($1); }
    | FLT_EL                            { $$ = new YAMLelement; $$->element_type = YAML_FLOAT; $$->element_value = new float($1); }
    | TRUE_EL                           { $$ = new YAMLelement; $$->element_type = YAML_TRUE; $$->element_value = NULL; }
    | FALSE_EL                          { $$ = new YAMLelement; $$->element_type = YAML_FALSE; $$->element_value = NULL; }
    | NULL_EL                           { $$ = new YAMLelement; $$->element_type = YAML_NULL; $$->element_value = NULL; }
    | INDENT_START map INDENT_END       { $$ = new YAMLelement; $$->element_type = YAML_MAP; $$->element_value = $2; }
    | INDENT_START sequence INDENT_END  { $$ = new YAMLelement; $$->element_type = YAML_SEQUENCE; $$->element_value = $2; }
;

%%

/* ADDITIONAL C CODE */

int main() {
    yyparse();
    
    if (root_map) {
        root_map->print(cout);
    } else if (root_seq) {
        root_seq->print(cout);
    }

    cout << endl;
    return 0;
}

void yyerror(const char *s) {
    cerr << "Error: " << s << endl;
}
