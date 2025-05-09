/*
	AVLTree.h file for the AVLTree Class
	Jacob Colley
*/

#include <iostream>
#include <string>
#include <vector>

using namespace std;

class AVLTree {

private:
	// TreeNode class for storing <key, value> pairs in the AVLTree
	class TreeNode {
	public:
		TreeNode* left;	// Left Child
		TreeNode* right;	// Right Child
		int key;
		string value;
		int height;			// Amount of "steps" away from a leaf node

		// Empty Constructor
		TreeNode() {
			left = nullptr;
			right = nullptr;
			height = 0;
		}

		// Parameterized Constructor
		TreeNode(int newKey, string newValue) {
			left = nullptr;
			right = nullptr;
			key = newKey;
			value = newValue;
			height = 0;
		}

		// Destructor
		~TreeNode() {}
	};
	// End of TreeNode Class

	TreeNode* root;	// Top of the tree
	int treeSize;		// Number of TreeNodes in tree

	// Calculates balance of a TreeNode
	int balance(TreeNode*&);

	// Helper functions for recursion
	bool insertHelp(int, string, TreeNode*&);
	void deleteHelp(TreeNode*&);
	void buildHelp(TreeNode*, TreeNode*&);
	bool findHelp(int, string&, TreeNode*);
	void findRangeHelp(int, int, vector<string>&, TreeNode*);

	// Functions to "fix" nodes
	void fixHeight(TreeNode*&);	// Fixes height after a Node has been moved
	void fix(TreeNode*&);			// Determines how to rotate Nodes

	// Rotations to keep tree balanced
	void slr(TreeNode*&);	// Single left rotation
	void srr(TreeNode*&);	// Single right rotation
	void dlr(TreeNode*&);	// Double left rotation
	void drr(TreeNode*&);	// Double right rotation

	// Help for printing
	void inOrderRight(TreeNode*, int, ostream&) const;	// Right child first in order traversal of the tree
	void selfPrint(TreeNode*, int, ostream&) const;		// Prints the given node at a provided "depth" of the tree

public:

	// Constructors and Destructor
   AVLTree();
   AVLTree(const AVLTree&);
   ~AVLTree();

	// = overload
   AVLTree& operator=(const AVLTree&);

	// Getters
	int getHeight() const;
	int getSize() const;

	// Inserts a TreeNode with the given key and value into the tree
	bool insert(int, string);

	// Finds values in the tree
	bool find(int, string&);
	vector<string> findRange(int, int);

	// << overload
	friend ostream& operator<<(ostream&, const AVLTree&);
};