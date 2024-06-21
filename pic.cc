#include "pic.hh"

void printAST(ASTNode* node, int depth) {
    // Indentation for better readability
    for (int i = 0; i < depth; ++i) {
        cout << " ~";
    }

    // Print node type and value
    switch (node->type) {
        case VARIABLE:
            cout << "Variable: " << *node->value << endl;
            break;
        case INT:
            cout << "Int: " << *node->value << endl;
            break;
        case FLOAT:
            cout << "Float: " << *node->value << endl;
            break;
        case BOOLEAN:
            cout << "Boolean: " << *node->value << endl;
            break;
        case STRING:
            cout << "String: " << *node->value << endl;
            break;
        case ARITHMETIC_OPERATOR:
            cout << "Arithmetic Operator: " << *node->value << endl;
            break;
        case BOOLEAN_OPERATOR:
            cout << "Boolean Operator: " << *node->value << endl;
            break;
        case COMPARISION_OPERATOR:
            cout << "Comparision Operator: " << *node->value << endl;
            break;
        case DECLARATION_ASSIGNMENT:
            cout << "Declaration Assignment: " << *node->value << endl;
            break;
        case ASSIGNMENT:
            cout << "Assignment: " << *node->value << endl;
            break;
        case COMPOUND_STATEMENT:
            cout << "Compound Statement: " << endl;
            break;
        case IF_STATEMENT:
            cout << "If Statement: " << endl;
            break;
        case IF_CONDITION:
            cout << "Condition: " << endl;
            break;
        case IF_THEN_STATEMENT:
            cout << "Then Statement: " << endl;
            break;
        case ELSE_STATEMENT:
            cout << "Else Statement: " << endl;
            break;
        default:
            cout << "Unknown Type" << endl;
    }

    for (ASTNode* child : node->children) {
        printAST(child, depth + 1);
    }
}

void printProgram(vector<ASTNode*>* program) {
    if (!program) return;
    for (ASTNode* node : *program) {
        printAST(node, 0);
    }
}
