typedef struct Node {
    struct Node *next;
    int key;
    char todo[256];
} Node;
