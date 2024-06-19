#include "pic.hh"

void printAST(ASTNode* node, int depth) {
    if (node == nullptr) return;

    // Indentation for better readability
    for (int i = 0; i < depth; ++i) {
        cout << "  ";
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
        case ARITHMETIC_OPERATOR:
            cout << "Arithmetic Operator: " << *node->value << endl;
            break;
        case ASSIGNMENT:
            cout << "Assignment: " << *node->value << endl;
            break;
        case BOOLEAN_OPERATOR:
            cout << "Boolean Operator: " << *node->value << endl;
            break;
        case BOOLEAN:
            cout << "Boolean: " << *node->value << endl;
            break;
        default:
            cout << "Unknown Type" << endl;
    }

    // Recursively print children nodes
    if (node->leftChild) {
        printAST(node->leftChild, depth + 1);
    }
    if (node->rightChild) {
        printAST(node->rightChild, depth + 1);
    }
}

void printProgram(vector<Statement*>* program) {
    if (!program) return;

    for (Statement* stmt : *program) {
        if (stmt) {
            switch (stmt->stype) {
                case DECLARATION:
                    cout << "Declaration:" << endl;
                    break;
                case REDEFINITION:
                    cout << "Redefinition:" << endl;
                    break;
                default:
                    cout << "Unknown Statement Type" << endl;
            }
            printAST(stmt->node, 1);
        }
    }
}
