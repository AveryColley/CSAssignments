/*
   Avery Colley
   Project #4 - Indexing with AVL Trees

   This file contains all the functions for the AVLTree Class
*/

#include "AVLTree.h"
#include <algorithm> // For max

// Constructor: Creates an empty AVLTree
AVLTree::AVLTree() {
   root = nullptr;
   treeSize = 0;
}

// Destructor: Deletes all the nodes in the AVLTree
AVLTree::~AVLTree() {
   deleteHelp(root);
}

// Copy constrcutor: Makes a copy of the given AVLTree
AVLTree::AVLTree(const AVLTree &avl) {
   *this = avl;
}

// Operator=: Sets an AVLTree to be equal to the given AVLTree avl
AVLTree& AVLTree::operator=(const AVLTree &avl) {
   // Handling empty Tree
   if(avl.getSize() == 0) {
      root = nullptr;
      treeSize = 0;
   } else {
      buildHelp(avl.root, root);
   }
   return *this;
}

// find: Returns true if the given key is in the AVLTree and changes value to that key's value
//       Returns false if the given key is not in the AVLTree and changes value to "Not in the Tree"
bool AVLTree::find(int key, string &value) {
   return findHelp(key, value, root);
}

// findRange: Returns a vector of strings corresponding to the values of the keys in the tree that lie
//            between min and max
vector<string> AVLTree::findRange(int min, int max) {
   vector<string> result = {};   // Creating result vector
   findRangeHelp(min, max, result, root);
   return result;
}

// findRangeHelp: Helper function for findRange. Recursively goes through the AVLTree, ignores nodes below the min
//                or above the max and adds the values of keys inbetween the min and the max to the given vector
void AVLTree::findRangeHelp(int min, int max, vector<string> &v, TreeNode* current) {
   // Base case
   if(current == nullptr) {
      return;
   }
   if(min == current->key) {
      v.push_back(current->value);
      findRangeHelp(min, max, v, current->right);  // If min was found, don't need to go left
   } else if(max == current->key) {
      v.push_back(current->value);
      findRangeHelp(min, max, v, current->left);   // If max was found, don't need to go right
   } else if(min < current->key && max > current->key) {
      v.push_back(current->value);
      // We go both left and right if the key is in the middle of the range
      findRangeHelp(min, max, v, current->left);
      findRangeHelp(min, max, v, current->right);
   } else {
      return;  // If min > current->key or max < current->key
   }
}

// fixHeight: Sets the height of the given TreeNode to the maximum value of the height of both of its subtrees
//            + 1. If a subtree is null, that height is -1
void AVLTree::fixHeight(TreeNode* &current) {
   int leftHeight;   // Height of left subtree
   int rightHeight;  // Height of right subtree
   if(current->left == nullptr) {
      leftHeight = -1;  // Null children have height = -1
   } else {
      leftHeight = current->left->height;
   }
   if(current->right == nullptr) {
      rightHeight = -1; // Null children have height = -1
   } else {
      rightHeight = current->right->height;
   }
   current->height = max(leftHeight, rightHeight) + 1;
}

// slr: Performs a single left rotation on the AVLTree with the given TreeNode as the problem Node
void AVLTree::slr(TreeNode* &current) {
   TreeNode* hook = current->right; // Sets hook Node
   TreeNode* temp = hook->left;     // Sets temp pointer in case hook has left child
   hook->left = current;
   current->right = temp;
   // Update root if necessary
   if (current == root) {
      root = hook;
   }
   current = hook;
   // Adjust heights on moved Nodes
   fixHeight(hook->left);
   fixHeight(hook);
}

// srr: Performs a single right rotation on the AVLTree with the given TreeNode as the problem Node
void AVLTree::srr(TreeNode* &current) {
   TreeNode* hook = current->left;  // Sets hook Node
   TreeNode* temp = hook->right;    // Sets temp pointer in case hook has right child
   hook->right = current;
   current->left = temp;
   // Update root if necessary
   if (current == root) {
      root = hook;
   }
   current = hook;
   //Adjust heights on moved Nodes
   fixHeight(hook->right);
   fixHeight(hook);
}

// drr: Performs a double right rotation on the AVLTree with the given TreeNode as the problem Node
void AVLTree::drr(TreeNode* &current) {
   slr(current->left);  // Single left rotation with Hook as problem
   srr(current);        // Single right rotation to fix the balance
}

// dlr : Performs a double left rotation on the AVLTree with the given TreeNode as the problem Node
void AVLTree::dlr(TreeNode* &current) {
   srr(current->right); // Single right rotation with Hook as the problem
   slr(current);        // Single left rotation to fix the balance
}

// balance: Checks the balance of the given TreeNode. A TreeNode is considered "balanced" when the balance is -1, 0 or 1.
int AVLTree::balance(TreeNode* &current) {
   int leftHeight;   // Height of left subtree
   int rightHeight;  // Height of right subtree
   if(current->left == nullptr) {
      leftHeight = -1;
   } else {
      leftHeight = current->left->height;
   }
   if(current->right == nullptr) {
      rightHeight = -1;
   } else {
      rightHeight = current->right->height;
   }
   return rightHeight - leftHeight;
}

// fix: Checks to see what kind of rotation needs to be done with the given TreeNode
//      If the given Node is NOT out of balance, nothing happens.
void AVLTree::fix(TreeNode* &current) {
   if(balance(current) < -1) {
      // Checks if double rotation is needed
      if(balance(current) - balance(current->left) < -2) {
         drr(current);
      } else {
         srr(current);
      }
   } else if(balance(current) > 1) {
      // Checks if double rotation is needed
      if(balance(current) - balance(current->right) > 2) {
         dlr(current);
      } else {
         slr(current);
      }
   }
}

// insertHelp: Helper function for insert. Recursively goes through the AVLTree and inserts a TreeNode at the correct spot with the
//             given <key, value> pair. Returns false if there's already a Node with the same key as provided and true otherwise
bool AVLTree::insertHelp(int key, string value, TreeNode* &current) {
   // Base case - Create Node
   if(current == nullptr) {
      current = new TreeNode(key, value);
      treeSize++; // Updating treeSize
      return true;
   }
   // Checking for duplicates. Duplicates are NOT allowed
   if(current->key == key) {
      return false;
   } else {
      // Navigate through tree going left if key is smaller than current node and right otherwise
      if(key < current->key) {
         if(insertHelp(key, value, current->left)) {
            // Checks balance
            if(balance(current) > 1 || balance(current) < -1) {
               fix(current);  // Off balance Nodes must be fixed
            }
            fixHeight(current);  // Updating height of Nodes after insertion
            return true;
         } else {
            // Duplicate was found earlier. Duplicates are NOT allowed.
            return false;
         }
      } else {
         if(insertHelp(key, value, current->right)) {
            if(balance(current) > 1 || balance(current) < -1) {
               fix(current);  // Off balance Nodes must be punished
            }
               fixHeight(current); // Updating height of Nodes after insertion
               return true;
         } else {
            // Duplicate was found earlier. Duplicates will not be tolerated
            return false;
         }
      }
   }
}

// insert: Inserts the given <key, value> pair as a TreeNode in the Tree. Returns true if the Node was inserted
//         successfully and false if the key is a duplicate key. Duplicates are not allowed
bool AVLTree::insert(int key, string value) {
   // Calls helper function
   return insertHelp(key, value, root);
}

// getHeight: Returns the height of the tree (Maximum amount of "hops" until a leaf node)
int AVLTree::getHeight() const {
   return root->height;
}

// getSize: Returns the amount of Nodes in the Tree
int AVLTree::getSize() const {
   return treeSize;
}

// deleteHelp: Helper function for the destructor. Recursively deletes Nodes through the Tree starting at the given TreeNode
void AVLTree::deleteHelp(TreeNode* &current) {
   // Base case
   if(current == nullptr) {
      return;
   }
   deleteHelp(current->left);    // Deals with the left subtree first
   deleteHelp(current->right);   // Kills right subtree second
   delete current;               // No Node left behind
}

// buildHelp: Helper function for the = overload. Goes through the tree recursively and creates an independent copy.
void AVLTree::buildHelp(TreeNode* copyMe, TreeNode* &current) {
   // Base case
   if(copyMe == nullptr) {
      return;
   }
   // Building new Nodes off of ones from the given copyMe Node and attaching them to the current pointer
   current = new TreeNode(copyMe->key, copyMe->value);
   current->height = copyMe->height;
   buildHelp(copyMe->left, current->left);   // Copying left subtree
   buildHelp(copyMe->right, current->right); // Cloning right subtree
}

// findHelp: Helper function for the find function. Recursively goes through the tree starting at current and searches
//           for the given key. If found replaces value with that key's value and returns true. If not found
//           replaces value with "Not in the Tree" and returns false
bool AVLTree::findHelp(int key, string &value, TreeNode* current) {
   // Base case
   if(current == nullptr) {
      value = "Not in the Tree"; // A warning
      return false;
   }
   // Checks key
   if(key == current->key) {
      value = current->value; // Updating value
      return true;
   } else if(key < current->key) {
      return findHelp(key, value, current->left);  // Going left when the key we are searching for is less
   } else {
      return findHelp(key, value, current->right); // Going right when the key we are searching for is more
   }
}

// selfPrint: Prints out the given TreeNode to os with 4 spaces per "depth" into the tree. Depth is simpy distance from root
void AVLTree::selfPrint(TreeNode* current, int depth, ostream &os) const {
   // Printing excess spaces
   for(int i = 0; i < 4 * depth; i++) {
      os << " ";
   }
   os << current->key << ", " << current->value << "\n";
}

// inOrderRight: A right child first in order traversal of the Tree starting at the given TreeNode.
//               Takes a "depth" of the node and an ostream&
void AVLTree::inOrderRight(TreeNode* current, int depth, ostream &os) const {
   // Base case
   if(current == nullptr) {
      return;
   }
   inOrderRight(current->right, depth + 1, os); // Handles right subtree
   selfPrint(current, depth, os);               // Printing Node
   inOrderRight(current->left, depth + 1, os);  // Handles left subtree
}

// operator<<: Allows for printing AVLTrees by simply calling os << AVLTree
ostream& operator<<(ostream &os, const AVLTree &avl) {
   avl.inOrderRight(avl.root, 0, os);
   return os;
}
