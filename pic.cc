#include "pic.hh"

#ifndef YAML_DEFS
#define YAML_DEFS

void YAMLelement::print(std::ostream &os) const {
    switch (element_type) {
        case YAML_MAP:
            ((YAMLmap*)element_value)->print(os);
            break;
        case YAML_SEQUENCE:
            ((YAMLsequence*)element_value)->print(os);
            break;
        case YAML_STRING:
            os << '"'<<*(string*)element_value<<'"';
            break;
        case YAML_INT:
            os << *(int*)element_value;
            break;
        case YAML_FLOAT:
            os << *(float*)element_value;
            break;
        case YAML_TRUE:
            os << "true";
            break;
        case YAML_FALSE:
            os << "false";
            break;
        case YAML_NULL:
            os << "null";
            break;
    }
}

void YAMLsequence::print(std::ostream &os) const {
    os << "[";
    for (int i = 0; i < elements.size(); i++) {
        elements[i]->print(os);
        if (i != elements.size() - 1) os << ", ";
    }
    os << "]";
}

void YAMLmap::print(std::ostream &os) const {
    os << "{";
    for (auto it = elements.begin(); it != elements.end(); it++) {
        os << '"' << *(it->first) << "\": ";
        it->second->print(os);
        if (next(it) != elements.end()) os << ", ";
    }
    os << "}";
}

#endif