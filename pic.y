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
    pair<string*, YAMLelement*> *pair_ptr;
    string *str_ptr;
    int int_val;
    float flt_val;
}
%type <element_ptr> trivial_element
%type <pair_ptr> pair
%type <map_ptr> map
%type <sequence_ptr> sequence
%type <str_ptr> STR_EL
%type <int_val> INT_EL
%type <flt_val> FLT_EL

%start program

%%
/* GRAMMAR */

program
    : sequence            { printf("1.1 "); root_seq = $1; }
    | map                 { printf("1.2 "); root_map = $1; }
;

sequence
    : DASH trivial_element NEWLINE              { printf("2.1 "); $$ = new YAMLsequence; $$->elements.push_back($2); }
    | DASH map                                  { printf("2.2 "); $$ = new YAMLsequence; ; $$->elements.push_back(new YAMLelement($2)); }
    | sequence DASH trivial_element NEWLINE     { printf("2.3 "); $1->elements.push_back($3); $$ = $1; }
    | sequence DASH map                         { printf("2.4 ");  $1->elements.push_back(new YAMLelement($3)); $$ = $1;  }
;

map
    : pair                     { printf("3.1 "); $$ = new YAMLmap(*$1); delete $1; }
    | map pair                 { printf("3.2 "); $1->elements.push_back(*$2); $$ = $1; delete $2; }
;

pair
    : STR_EL COLON trivial_element NEWLINE                      { printf("4.1 "); cout<<"("<<*$1<<": )"; ; $$ = new pair<string*, YAMLelement*>($1, $3); }
    | STR_EL COLON NEWLINE INDENT_START sequence                { printf("4.2 "); $$ = new pair<string*, YAMLelement*>($1, new YAMLelement($5)); }
    | STR_EL COLON NEWLINE INDENT_START map                     { printf("4.3 "); $$ = new pair<string*, YAMLelement*>($1, new YAMLelement($5)); }
;

trivial_element
    : STR_EL                            { printf("5.1 ");cout<<"("<<*$1<<") "; $$ = new YAMLelement; $$->element_type = YAML_STRING; $$->element_value = $1; }
    | INT_EL                            { printf("5.2 ");cout<<"("<<$1<<") "; $$ = new YAMLelement; $$->element_type = YAML_INT; $$->element_value = new int($1); }
    | FLT_EL                            { printf("5.3 ");cout<<"("<<$1<<") "; $$ = new YAMLelement; $$->element_type = YAML_FLOAT; $$->element_value = new float($1); }
    | TRUE_EL                           { printf("5.4 "); $$ = new YAMLelement; $$->element_type = YAML_TRUE; $$->element_value = NULL; }
    | FALSE_EL                          { printf("5.5 "); $$ = new YAMLelement; $$->element_type = YAML_FALSE; $$->element_value = NULL; }
    | NULL_EL                           { printf("5.6 "); $$ = new YAMLelement; $$->element_type = YAML_NULL; $$->element_value = NULL; }
;

%%

/* ADDITIONAL C CODE */

int main() {
    yyparse();
    cout<<endl;
    
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
