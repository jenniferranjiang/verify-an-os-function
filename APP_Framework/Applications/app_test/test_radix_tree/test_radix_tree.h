/**
 * @file:    test_radix_tree.h
 * @brief:   Implement a simple radix tree
 * @version: 1.0
 * @date:    2023/5/24
 */

#include <transform.h>

#define NODE_SIZE 4
#define BITS 2
#define CHECK_BITS(key, pos) ((((unsigned int)(key)) << (sizeof(int) * 8 - (pos + 1) * BITS)) >> (sizeof(int) * 8 - BITS))

const int radix_tree_height = sizeof(void *) * 8 / BITS; // Height of tree

typedef struct radix_node
{
    void *value;
    struct radix_node *child[NODE_SIZE];
    struct radix_node *parent;
} radix_node;

radix_node *CreateNode();
int InsertNode(radix_node *root, unsigned int key, void *value);
void DeleteNode(radix_node *root, unsigned int key);
void *FindNode(radix_node *root, unsigned int key);
void DestroyTree(radix_node *root);