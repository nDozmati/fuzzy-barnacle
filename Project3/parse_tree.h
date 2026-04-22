//****************************************************************
// File: parse_tree.h
// Author: David W. Juedes
//
// Copyright 2007, All rights reserved.
// Purpose: This .h file includes a hierarchy 
// of classes that define possible 
// instructions in the pfig language
//  
// In general, there are statements, 
// boolean expressions, and integer_expressions
//
//******************************************************************

/**
 * @file parse_tree.h
 * @brief definitions for parse tree nodes and expression evaluation classes for TreeBuilder language
 * @date 2026-04-22
 * @author Nicolas Dozmati & Matthew Carpenter
 * @note Code labeled with [TB] was added specifically to implement TreeBuilder language extensions
 */

#include <map>
#include <string>
#include <set>
#include <algorithm>
#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>

using namespace std;

// [TB] Tree node structure
struct Node {
    string name;
    int weight;
    vector<Node*> children;
};

// [TB] Global tree structures (declared in tree_builder.cc)
extern unordered_map<string, Node*> node_map;
extern Node* tree_root;
extern ofstream debug_out;

class integer_expression {
 public:
  virtual int evaluate_expression(map<string, int> &sym_tab) =0;
};


class boolean_expression {
 public:
     virtual bool evaluate_expression(map<string, int> &sym_tab)=0;
};


class string_expression {
 public:
  virtual string evaluate_string(map<string, int> &sym_tab) =0;
};


class string_constant: public string_expression {
 public:
  string_constant(char *val) { saved_val = val; }

  virtual string evaluate_string(map<string, int> &sym_tab) {
    return saved_val;
  }
 private:
  string saved_val;
};

class string_concat: public string_expression {
 public:
  string_concat(string_expression *left, string_expression *right) {
    l = left;
    r = right;
  }

  virtual string evaluate_string(map<string, int> &sym_tab) {
    return l->evaluate_string(sym_tab) + r->evaluate_string(sym_tab);
  }
 private:
  string_expression *l;
  string_expression *r;
};

class string_concat_int: public string_expression {
 public:
  string_concat_int(string_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual string evaluate_string(map<string, int> &sym_tab) {
    return l->evaluate_string(sym_tab) + to_string(r->evaluate_expression(sym_tab));
  }
 private:
  string_expression *l;
  integer_expression *r;
};


class int_constant:public integer_expression {
 public:
  int_constant(int val) {saved_val = val;}

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return saved_val;
  }
 private:
  int saved_val;
};

class variable: public integer_expression {
 public:
  variable(char *in_val) {//cout << "Found variable = " << in_val << endl; 
                          saved_val =in_val;}

  virtual int evaluate_expression(map<string, int> &sym_tab) {

    map<string,int>::iterator p;
    p =sym_tab.find(saved_val);
    //cout << "Looking up variable " << saved_val << endl;
    if (p!=sym_tab.end()) {
      //cout << "Returning value of variable " << saved_val << endl;
      //cout << "= " << p->second << endl;

      return p->second;
    } else {
      // ERROR .... for now return -1;
      // Should throw error!
      return -1;
    }

  }
 private:
  string saved_val;
  
};

class neg_constant: public integer_expression {
 public:
  neg_constant(integer_expression *ptr) {
    eval_ptr = ptr;
  }
  
  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return -eval_ptr->evaluate_expression(sym_tab);
  }
  integer_expression *eval_ptr;
};



class plus_expr: public integer_expression {
 public:
  plus_expr(integer_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) + r->evaluate_expression(sym_tab);
  }
  
  private:
    integer_expression *l;
    integer_expression *r;
};

class minus_expr: public integer_expression {
 public:
  minus_expr(integer_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) - r->evaluate_expression(sym_tab);
  }
  
  private:
    integer_expression *l;
    integer_expression *r;
};

class mult_expr: public integer_expression {
 public:
  mult_expr(integer_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) * r->evaluate_expression(sym_tab);
  }
  
  private:
    integer_expression *l;
    integer_expression *r;
};


class div_expr: public integer_expression {
 public:
  div_expr(integer_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) / r->evaluate_expression(sym_tab);
  }
  
  private:
    integer_expression *l;
    integer_expression *r;
};

class mod_expr: public integer_expression {
 public:
  mod_expr(integer_expression *left, integer_expression *right) {
    l = left;
    r = right;
  }

  virtual int evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) % r->evaluate_expression(sym_tab);
  }
  
  private:
    integer_expression *l;
    integer_expression *r;
};


class less_expr: public boolean_expression {
 public:
  less_expr(integer_expression *left, integer_expression *right) {
    l=left; r=right;
  }
  virtual bool evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) < r->evaluate_expression(sym_tab);
  }
 private:
  integer_expression *l;
  integer_expression *r;
};
class greater_expr: public boolean_expression {
 public:
  greater_expr(integer_expression *left, integer_expression *right) {
    l=left; r=right;
  }
  virtual bool evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) > r->evaluate_expression(sym_tab);
  }
 private:
  integer_expression *l;
  integer_expression *r;
};
class ge_expr: public boolean_expression {
 public:
  ge_expr(integer_expression *left, integer_expression *right) {
    l=left; r=right;
  }
  virtual bool evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) >= r->evaluate_expression(sym_tab);
  }
 private:
  integer_expression *l;
  integer_expression *r;
};
class le_expr: public boolean_expression {
 public:
  le_expr(integer_expression *left, integer_expression *right) {
    l=left; r=right;
  }
  virtual bool evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) <= r->evaluate_expression(sym_tab);
  }
 private:
  integer_expression *l;
  integer_expression *r;
};
class ee_expr: public boolean_expression {
 public:
  ee_expr(integer_expression *left, integer_expression *right) {
    l=left; r=right;
  }
  virtual bool evaluate_expression(map<string, int> &sym_tab) {
    return l->evaluate_expression(sym_tab) == r->evaluate_expression(sym_tab);
  }
 private:
  integer_expression *l;
  integer_expression *r;
};



class statement {
 public:
  virtual void evaluate_statement(map<string, int> &sym_tab) =0;
};

class compound_statement: public statement {
 public:
  compound_statement(statement *first, compound_statement *rest) {
    f = first;
    r = rest;
  }
  
  virtual void evaluate_statement(map<string, int> &sym_tab) {
    if (f!=NULL) {
      f->evaluate_statement(sym_tab);
    }
    if (r!=NULL) {
      r->evaluate_statement(sym_tab);
    }
  }
 private:
  compound_statement *r;
  statement *f;
};
  

class while_statement: public statement {
 public:
  while_statement(boolean_expression *cond, compound_statement *body) {
    c=cond;
    b=body;
  }

  virtual void evaluate_statement(map<string, int> &sym_tab) {
    while (c->evaluate_expression(sym_tab)) {
      b->evaluate_statement(sym_tab);
    }
  }
    

    
  private:
    boolean_expression *c;
    compound_statement *b;
  };

class for_statement: public statement {
 public:
  for_statement(char *var, integer_expression *low, integer_expression *high, compound_statement *body) {
    v = var;
    l = low;
    h = high;
    b = body;
  }

  virtual void evaluate_statement(map<string, int> &sym_tab) {
    int low_val = l->evaluate_expression(sym_tab);
    int high_val = h->evaluate_expression(sym_tab);
    for (int i = low_val; i <= high_val; i++) {
      sym_tab[v] = i;
      b->evaluate_statement(sym_tab);
    }
  }
 private:
  string v;
  integer_expression *l;
  integer_expression *h;
  compound_statement *b;
};

class assignment_statement: public statement {

 public:
  assignment_statement(char *id, integer_expression *rhs) {
    ident = id;
    r_side = rhs;
  }
  virtual void evaluate_statement(map<string, int> &sym_tab) {
    
    int temp = r_side->evaluate_expression(sym_tab);

    //cout << "Assigning" << ident << " to " << temp << endl;

    sym_tab[ident]=temp;
  }


  private: 
    string ident;
    integer_expression *r_side;
  };

class print_statement: public statement {
 public:
  print_statement(string_expression *expr) {
    e=expr;
  }
  virtual void evaluate_statement(map<string, int> &sym_tab) {
    // Print the tree instead of the string, as per project requirements
    extern Node* tree_root;
    extern void print_tree(Node*, ostream&);
    if (tree_root) {
      print_tree(tree_root, cout);
      cout << endl;
    }
  }
    

  private:
    string_expression *e;

};

/*
TreeBuilder language specifics:
*/

class buildnode_statement : public statement {
public:
    buildnode_statement(string_expression *n, integer_expression *w, string_expression *p) {
        name_expr = n;
        weight_expr = w;
        parent_expr = p;
    }

    virtual void evaluate_statement(map<string, int> &sym_tab) {
        string n = name_expr->evaluate_string(sym_tab);
        int w = weight_expr->evaluate_expression(sym_tab);
        string p = parent_expr ? parent_expr->evaluate_string(sym_tab) : "";

        // [TB] Output to debug file (very handy!)
        extern ofstream debug_out;
        debug_out << "Building node: " << n << " weight=" << w;
        if (!p.empty()) debug_out << " parent=" << p;
        debug_out << endl;

        // [TB] Build the tree
        extern unordered_map<string, Node*> node_map;
        extern Node* tree_root;
        Node* node = new Node{n, w, {}};
        node_map[n] = node;
        if (p.empty()) {
            tree_root = node;
        } else {
            auto it = node_map.find(p);
            if (it != node_map.end()) {
                it->second->children.push_back(node);
            }
        }
    }
private:
    string_expression *name_expr;
    integer_expression *weight_expr;
    string_expression *parent_expr;
};

class childof_statement : public statement {
public:
    string child;
    string parent;

    childof_statement(char *c, char *p) {
        child = c;
        parent = p;
    }

    virtual void evaluate_statement(map<string, int> &sym_tab) {
        cout << child << " is a child of " << parent << endl;
    }
};
