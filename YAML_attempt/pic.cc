#include "pic.hh"

#ifndef YAML_DEFS
#define YAML_DEFS

YAMLelement::YAMLelement() {
    element_type = YAML_NULL;
    element_value = nullptr;
}

YAMLelement::YAMLelement(YAMLsequence* seq) {
    element_type = YAML_SEQUENCE;
    element_value = seq;
}

YAMLelement::YAMLelement(YAMLmap* map) {
    element_type = YAML_MAP;
    element_value = map;
}

YAMLmap::YAMLmap() {
    elements = {};
}

YAMLmap::YAMLmap(pair<string*, YAMLelement*> p) {
    elements = {p};
}

void YAMLelement::print(std::ostream &os) const {
    switch (element_type) {
        case YAML_MAP:
            ((YAMLmap*)element_value)->print(os);
            break;
        case YAML_SEQUENCE:
            ((YAMLsequence*)element_value)->print(os);
            break;
        case YAML_STRING:
            os << '"'<< *((string*)element_value)<<'"';
            break;
        case YAML_INT:
            os << *((int*)element_value);
            break;
        case YAML_FLOAT:
            os << *((float*)element_value);
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
        if (i != elements.size() - 1) {
            os << ", ";
        }
    }
    os << "]";
}

void YAMLmap::print(std::ostream &os) const {
    os << "{";
    for (int i = 0; i < elements.size(); i++) {
        os << "\"" << *elements[i].first << "\": ";
        elements[i].second->print(os);
        if (i != elements.size() - 1) {
            os << ", ";
        }
    }
    os << "}";
}

#endif