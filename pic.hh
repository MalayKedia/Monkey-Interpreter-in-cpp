#include<bits/stdc++.h>
using namespace std;

struct YAMLelement;
struct YAMLsequence;
struct YAMLmap;

enum dtype{
    YAML_MAP,
    YAML_SEQUENCE,
    YAML_STRING,
    YAML_INT,
    YAML_FLOAT,
    YAML_TRUE,
    YAML_FALSE,
    YAML_NULL
};

struct YAMLelement {
    dtype element_type;
    // 0: map, 1: sequence, 2: string, 3: int, 4: float, 5: true, 6: false, 7: null
    void *element_value;

    void print(std::ostream &os) const;
};

struct YAMLsequence {
    vector<YAMLelement*> elements;
    void print(std::ostream &os) const;
};

struct YAMLmap {
    map<string*, YAMLelement*> elements;
    void print(std::ostream &os) const;
};