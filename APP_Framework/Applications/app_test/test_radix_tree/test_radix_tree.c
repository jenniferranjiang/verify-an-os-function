/**
 * @file:    test_radix_tree.c
 * @brief:   Implement a simple radix tree
 * @version: 1.0
 * @date:    2023/5/24
 */

#include "test_radix_tree.h"

/**
 * @description: Create a radix tree node
 * @return node pointer
 */
radix_node *CreateNode()
{
    radix_node *n = (radix_node *)malloc(sizeof(radix_node));
    if (n != NULL)
    {
        n->parent = NULL;
        n->value = NULL;
        for (int i = 0; i < NODE_SIZE; ++i)
        {
            n->child[i] = NULL;
        }
    }
    return n;
}

/**
 * @description: Insert a new node to radix tree
 * @param root - radix tree root
 * @param key - new node key
 * @param value - new node value
 * @return void
 */
int InsertNode(radix_node *root, unsigned int key, void *value)
{
    if (root == NULL)
    {
        return -1; // The root node is empty
    }
    radix_node *cur = root;
    int temp;
    for (int i = radix_tree_height - 1; i >= 0; --i)
    {
        temp = CHECK_BITS(key, i);
        if (!cur->child[temp])
        {
            cur->child[temp] = CreateNode();
            if (!cur->child[temp])
                return -2; // Failed to apply for a node
            cur->child[temp]->parent = cur;
        }
        cur = cur->child[temp];
    }
    if (cur->value == value)
        return -3; // Repeat insertion
    if (cur->value != NULL)
        return -4; // Already occupied
    cur->value = value;
    return 0;
}

/**
 * @description: Delete a node from radix tree
 * @param root - radix tree root
 * @param key - key which is needed to delete
 * @return void
 */
void DeleteNode(radix_node *root, unsigned int key)
{
    if (root == NULL)
    {
        return;
    }
    radix_node *cur = root;
    int temp;
    for (int i = radix_tree_height - 1; i >= 0; --i)
    {
        temp = CHECK_BITS(key, i);
        cur = cur->child[temp];
        if (!cur)
            break;
    }

    if (!cur)
        return;

    cur->parent->child[temp] = NULL;
    free(cur);
}

/**
 * @description: find a node by key
 * @param root - radix tree root
 * @param key - key which is needed to find
 * @return value pointer corresponding to key
 */
void *FindNode(radix_node *root, unsigned int key)
{
    if (root == NULL)
    {
        return NULL;
    }
    radix_node *cur = root;
    int temp;
    for (int i = radix_tree_height - 1; i >= 0; --i)
    {
        temp = CHECK_BITS(key, i);
        cur = cur->child[temp];
        if (!cur)
            break;
    }
    if (!cur)
        return NULL;
    return cur->value;
}

/**
 * @description: Destroy the radix tree
 * @param root - radix tree root
 * @return void
 */
void DestroyTree(radix_node *root)
{
    if (root == NULL)
    {
        return;
    }
    for (int i = 0; i < NODE_SIZE; i++)
    {
        DestroyTree(root->child[i]);
    }
    free(root);
}

void TestRadix()
{
    char values[][16] = {
        "what",
        "where",
        "why",
        "how",
        "hello!",
        "apple",
        "12345"};
    unsigned int keys[] = {1, 2, 3, 4, 5, 6, 7};

    printf("\nCreate tree and add key & value:\n");
    radix_node *root = CreateNode();
    if (!root)
        printf("Create node failed.\n");

    int num = sizeof(keys) / sizeof(keys[0]);
    for (int i = 0; i < num - 1; ++i)
    {
        InsertNode(root, keys[i], &values[i]);
    }

    for (int i = 0; i < num; ++i)
    {
        char *v = (char *)FindNode(root, keys[i]);
        if (v)
            printf("keys[%d] %x, values[%d] = %s\n", i, keys[i], i, v);
        else
            printf("keys[%d] %x not found\n", i, keys[i]);
    }

    printf("\nDelete \"where\" and \"how\":\n");
    DeleteNode(root, keys[1]);
    DeleteNode(root, keys[3]);

    for (int i = 0; i < num; ++i)
    {
        char *v = (char *)FindNode(root, keys[i]);
        if (v)
            printf("keys[%d] %x, values[%d] = %s\n", i, keys[i], i, v);
        else
            printf("keys[%d] %x not found\n", i, keys[i]);
    }

    printf("\nInsert \"where\" and \"12345\":\n");
    InsertNode(root, keys[1], &values[1]);
    InsertNode(root, keys[6], &values[6]);

    for (int i = 0; i < num; ++i)
    {
        char *v = (char *)FindNode(root, keys[i]);
        if (v)
            printf("keys[%d] %x, values[%d] = %s\n", i, keys[i], i, v);
        else
            printf("keys[%d] %x not found\n", i, keys[i]);
    }

    printf("\nDestroy tree:\n");
    DestroyTree(root);
    root = NULL;

    for (int i = 0; i < num; ++i)
    {
        char *v = (char *)FindNode(root, keys[i]);
        if (v)
            printf("keys[%d] %x, values[%d] = %s\n", i, keys[i], i, v);
        else
            printf("keys[%d] %x not found\n", i, keys[i]);
    }
}

PRIV_SHELL_CMD_FUNCTION(TestRadix, Implement a simple radix tree, PRIV_SHELL_CMD_MAIN_ATTR);