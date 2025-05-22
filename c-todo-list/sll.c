#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdbool.h>
// #define NULL ((void *)0)                for when im feeling psychotic

// typedef enum bool { false = 0, true = 1 } bool;
char gchar(void) {
    char c;
    if (read(0, &c, 1) == 1)
        return c;
    else 
        return EOF;
}

void flushinput() {
    char c;
    while ((c = gchar()) != '\n' && c != EOF);
}

typedef struct Node {
    struct Node *next;
    char *todo;
    int key;
} Node;

Node *init_node() {
    Node *p = malloc(sizeof(Node));
    p->next = NULL;
    return p;
}

typedef struct List {
    Node *head;
    Node *tail;
} List;

void init_list(List *list) {
    Node *head = NULL;
    Node *tail= NULL;
};

bool empty(List *list) {
    return list->head == NULL;
}

Node *search(List *list, int key) {
    if (empty(list))
        return NULL;
    else {
        Node *p = list->head;
        
        while (p != NULL) {
            if (p->key == key)
                return p;
            p = p->next;
        }
    }
    return NULL;
}

void updatekeys(List *list) {
    if (empty(list))
        return;

    int key = 1;
    for (Node *p = list->head; p != NULL; p = p->next) 
        p->key = key++;
}

size_t slen(const char *s) {
    const char *p = s;
    while (*p) p++;
    return p - s;
}

void insert(List *list, char *todo) {
    // Initializing the node, might move this to inside this block
    Node *p = init_node();

    // Assigning the new nodes position
    if (empty(list)) {
        list->head = p;
        list->tail = p;
    }
    else {
        list->tail->next = p;
        list->tail = p;
    }

    // Setting the key
    int key = 1;
    for (Node *q = list->head; q != NULL; q = q->next)
        p->key = key++;

    // Pointing its todo 
    p->todo = malloc(slen(todo) + 1);     // Allocate the right amount of mem for the str
    char *lp = p->todo;
    while (*todo)
        *lp++ = *todo++;
}

void delete(List *list, int key) {
    key = key - '0';
    Node *p = search(list, key);

    if (p == NULL)
        return;

    if (p == list->head) 
        list->head = list->head->next;
    else {
        Node *prev = list->head;
        for (; prev->next != p; prev = prev->next);

        prev->next = p->next;

        if (p == list->tail) 
            list->tail = prev;
    }
    free(p->todo);
    free(p);
    updatekeys(list);
}

void printlist(List *list) {
    if (empty(list))
        return;

    Node *p = list->head;
    while (p != NULL) {
        printf("%d - %s", p->key, p->todo);
        p = p->next;
    }
}

void read_from_db(List *list, char *filename) {
    int fd = open(filename, O_RDONLY);
    char buffer[BUFSIZ];
    char *bp = buffer;
    char c;
    while (read(fd, buffer, BUFSIZ) > 0)
        ;

    char temp[256];
    char *tp = temp;
    while (*bp != EOF)
        if (*bp == '\n') {
            *tp++ = *bp;
            *tp = '\0';
            insert(list, temp);
            tp = temp;
            bp++;
        }
        else {
            *tp++ = *bp++;
        }
}

int main() {
    List list;
    init_list(&list);
    read_from_db(&list, "./test.txt");

    while (1 == 1) {
        // system("clear");
        printlist(&list);
 
        printf("\n\nEnter a command\n\n");
        char c = gchar();
        flushinput();

        if (c == 'a') {
            printf("Enter what you need to do\n\n");
            insert(&list, "added item to the list\n");
        }
        else if (c == 'd') {
            printf("Enter the number you wish to delete\n\n");
            char n = gchar();
            flushinput();
            delete(&list, n);
        }
        else if (c == 'e') {
            break;
        }
    }
    return 0;
}
