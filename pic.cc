#include "pic.hh"
#include "objects.cpp"
#include "env.cpp"

Object* executeAST(ASTNode* node, Scope* sTable){
    switch (node->type) {
        case INT:
        case FLOAT:
            return new NumberObject(stod(*node->value));
        case BOOLEAN:
            return new BoolObject(*node->value == "true");
        case STRING:
            return new StringObject(node->value);
        case IDENTIFIER:
            return sTable->checkAndReturnClone(*node->value);

        case ARITHMETIC_OPERATOR:
        {
            if (*node->value == "UMINUS"){
                Object* exp = executeAST(node->children[0], sTable);

                if (exp->otype != ObjectType::NUMBER){
                    cerr<<"Expected a number"<<endl;
                    delete exp;
                    return NULL;
                }
                else{
                    NumberObject* numExp = dynamic_cast<NumberObject*>(exp);
                    *(double*)(numExp->value) = -(*(double*)(numExp->value));
                    return exp;
                }
            }
            else{
                Object* lhs = executeAST(node->children[0], sTable);
                Object* rhs = executeAST(node->children[1], sTable);

                if (lhs->otype != ObjectType::NUMBER || rhs->otype != ObjectType::NUMBER){
                    cerr<<"Expected a number"<<endl;
                    return NULL;
                }
                else{
                    NumberObject* numLhs = dynamic_cast<NumberObject*>(lhs);
                    NumberObject* numRhs = dynamic_cast<NumberObject*>(rhs);
                    
                    if (*node->value == "PLUS"){
                        *(double*)(numLhs->value) += *(double*)(numRhs->value);
                    }
                    else if (*node->value == "MINUS"){
                        *(double*)(numLhs->value) -= *(double*)(numRhs->value);
                    }
                    else if (*node->value == "MULTIPLY"){
                        *(double*)(numLhs->value) *= *(double*)(numRhs->value);
                    }
                    else if (*node->value == "DIVIDE"){
                        if (*(double*)(numRhs->value) == 0){
                            cerr<<"Division by zero"<<endl;
                            delete lhs; delete rhs;
                            return NULL;
                        }
                        else
                            *(double*)(numLhs->value) /= *(double*)(numRhs->value);
                    }
                    else if (*node->value == "POWER"){
                        *(double*)(numLhs->value) = pow(*(double*)(numLhs->value), *(double*)(numRhs->value));
                    }
                    else {
                        cerr<<"Unknown operator"<<endl;
                        delete lhs; delete rhs;
                        return NULL;
                    }
                    delete rhs;
                    return lhs;
                }
            }
        }

        case BOOLEAN_OPERATOR:
        {
            if (*node->value == "NOT"){
                Object* exp = executeAST(node->children[0], sTable);

                if (exp->otype != ObjectType::BOOL){
                    cerr<<"Expected a boolean"<<endl;
                    delete exp;
                    return NULL;
                }
                else{
                    BoolObject* boolExp = dynamic_cast<BoolObject*>(exp);
                    *(bool*)(boolExp->value) = !(*(bool*)(boolExp->value));
                    return exp;
                }
            }
            else{
                Object* lhs = executeAST(node->children[0], sTable);
                Object* rhs = executeAST(node->children[1], sTable);

                if (lhs->otype != ObjectType::BOOL || rhs->otype != ObjectType::BOOL){
                    cerr<<"Expected a boolean"<<endl;
                    delete lhs; delete rhs;
                    return NULL;
                }
                else{
                    BoolObject* boolLhs = dynamic_cast<BoolObject*>(lhs);
                    BoolObject* boolRhs = dynamic_cast<BoolObject*>(rhs);

                    if (*node->value == "AND"){
                        *(bool*)(boolLhs->value) = (*(bool*)(boolLhs->value) && *(bool*)(boolRhs->value));
                    }
                    else if (*node->value == "OR"){
                        *(bool*)(boolLhs->value) = (*(bool*)(boolLhs->value) || *(bool*)(boolRhs->value));
                    }
                    else {
                        cerr<<"Unknown operator"<<endl;
                        delete lhs; delete rhs;
                        return NULL;
                    }
                    delete rhs;
                    return lhs;
                }
            }
        }

        case COMPARISION_OPERATOR:
        {
            Object* lhs = executeAST(node->children[0], sTable);
            Object* rhs = executeAST(node->children[1], sTable);

            if (lhs->otype != ObjectType::NUMBER || rhs->otype != ObjectType::NUMBER){
                cerr<<"Expected a number"<<endl;
                return NULL;
            }
            else{
                NumberObject* numLhs = dynamic_cast<NumberObject*>(lhs);
                NumberObject* numRhs = dynamic_cast<NumberObject*>(rhs);

                if (*node->value == "EQ"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) == *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else if (*node->value == "NEQ"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) != *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else if (*node->value == "LT"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) < *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else if (*node->value == "GT"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) > *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else if (*node->value == "LTEQ"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) <= *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else if (*node->value == "GTEQ"){
                    BoolObject* boolobj = new BoolObject(*(double*)(numLhs->value) >= *(double*)(numRhs->value));
                    delete lhs; delete rhs;
                    return boolobj;
                }
                else {
                    cerr<<"Unknown operator"<<endl;
                    delete lhs; delete rhs;
                    return NULL;
                }
            }
        }

        case TERNARY_OPERATOR:
        {
            Object* condition = executeAST(node->children[0], sTable);

            if (condition->otype != ObjectType::BOOL){
                cerr<<"Expected a boolean"<<endl;
                delete condition;
                return NULL;
            }
            else{
                BoolObject* boolCondition = dynamic_cast<BoolObject*>(condition);
                Object* result = NULL;

                if (*(bool*)(boolCondition->value)){
                    result = executeAST(node->children[1], sTable);
                }
                else{
                    result = executeAST(node->children[2], sTable);
                }
                delete condition;
                return result;
            }
        }

        case DECLARATION_ASSIGNMENT:
            sTable->insertNew(*node->children[0]->value, executeAST(node->children[1], sTable));
            return NULL;
        case ASSIGNMENT:
            sTable->checkAndUpdateVal(*node->children[0]->value, executeAST(node->children[1], sTable));
            return NULL;
        case EMPTY:
            return NULL;

        case COMPOUND_STATEMENT:
        {
            Scope* newScope = new Scope(sTable);
            for (ASTNode* child : node->children){
                executeAST(child, newScope);
            }
            delete newScope;
            return NULL;
        }

        case PRINT_STATEMENT:
        {
            Object* result = executeAST(node->children[0], sTable);
            cout<<result->str()<<endl;
            delete result;
            return NULL;
        }

        default:
            cerr << "Unknown Type" << endl;
            return NULL;
    }
}