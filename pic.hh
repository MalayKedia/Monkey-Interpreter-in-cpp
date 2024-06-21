#include <bits/stdc++.h>
using namespace std;

enum Type {
    VARIABLE,
    INT,
    FLOAT,
    BOOLEAN,
    STRING,
    ARITHMETIC_OPERATOR,
    BOOLEAN_OPERATOR,
    COMPARISION_OPERATOR,
    DECLARATION_ASSIGNMENT,
    ASSIGNMENT,
    EMPTY,
    COMPOUND_STATEMENT,
    IF_STATEMENT,
    IF_CONDITION,
    IF_THEN_STATEMENT,
    ELSE_STATEMENT,
};

struct ASTNode {
    Type type;
    string* value;
    
    vector<ASTNode*> children;

    ASTNode(const Type& type, string* value) 
        : type(type), value(value) 
        { children = vector<ASTNode*>(); }
    
    ASTNode(const Type& type, string* value, ASTNode* child) 
        : type(type), value(value) 
        { children = vector<ASTNode*>{child}; }
    
    ASTNode(const Type& type, string* value, ASTNode* child1, ASTNode* child2) 
        : type(type), value(value) 
        { children = vector<ASTNode*>{child1, child2}; }
    
    ASTNode(const Type& type, string* value, ASTNode* child1, ASTNode* child2, ASTNode* child3) 
        : type(type), value(value) 
        { children = vector<ASTNode*>{child1, child2, child3}; }
    
    ASTNode(const Type& type, string* value, vector<ASTNode*> children) 
        : type(type), value(value), children(children) { }

    void addChild(ASTNode* child) {
        children.push_back(child);
    }
};