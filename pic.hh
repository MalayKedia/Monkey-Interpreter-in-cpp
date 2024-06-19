#include <bits/stdc++.h>
using namespace std;

enum StatementType{
    DECLARATION,
    REDEFINITION,
};

enum Type {
    VARIABLE,
    INT,
    FLOAT,
    BOOLEAN,
    ARITHMETIC_OPERATOR,
    BOOLEAN_OPERATOR,
    ASSIGNMENT,
};

struct ASTNode;
struct Statement;

struct Statement {
    StatementType stype;
    ASTNode* node;

    Statement(StatementType stype, ASTNode* node)
        : stype(stype), node(node) {
        }
};

struct ASTNode {
    Type type;
    string* value;
    
    ASTNode* leftChild;
    ASTNode* rightChild;

    ASTNode(){
        leftChild=NULL;
        rightChild=NULL;
    
    }

    ASTNode(const Type& type, string* value)
        : type(type), value(value) {
            leftChild=NULL;
            rightChild=NULL;
        }

    ASTNode(const Type& type, string* value, ASTNode* leftChild, ASTNode* rightChild)
        : type(type), value(value), leftChild(leftChild) , rightChild(rightChild){
        }

};