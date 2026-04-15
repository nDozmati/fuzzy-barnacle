#ifndef TREE_NODE_H
#define TREE_NODE_H

#include <string>
#include <vector>
using namespace std;

class TreeNode {
public:
    string name;
    int weight;
    TreeNode* parent;
    vector<TreeNode*> children;

    TreeNode(string n, int w) {
        name = n;
        weight = w;
        parent = nullptr;
    }

    void addChild(TreeNode* child) {
        children.push_back(child);
        child->parent = this;
    }
};

#endif