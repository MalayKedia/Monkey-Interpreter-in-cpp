#include <bits/stdc++.h>
using namespace std;

enum StatementType{
    LET,

};

enum Type {
    INT,
    FLOAT,
    UMINUS,
    ARITHMETIC_OPERATOR
    
};

struct Statement {
    StatementType stype;
    ASTNode* node;
};

struct ASTNode {
    Type type;
    string value;
    
    ASTNode* leftChild;
    ASTNode* rightChild;

    ASTNode(){
        leftChild=NULL;
        rightChild=NULL;
    
    }

    ASTNode(const Type& type, const string& value)
        : type(type), value(value) {
            leftChild=NULL;
            rightChild=NULL;
        }

    ASTNode(const Type& type, const string& value, ASTNode* leftChild, ASTNode* rightChild)
        : type(type), value(value), leftChild(leftChild) , rightChild(rightChild){
        }

};