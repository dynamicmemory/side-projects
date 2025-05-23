#include <stdio.h>             // allows printing, could remove and write my own
#include <unistd.h>            // Reading stdin, stdout, stderr
#include <fcntl.h>             // system calls to open and close file 
#include <stdlib.h>            // system calls to allocate memory from the heap
#include <stdbool.h>           // imports booleans.... yep that's right
// #define NULL ((void *)0)                for when im feeling psychotic

char gchar(void) {
    char c;
    if (read(0, &c, 1) == 1)
        return c;
    else 
        return EOF;
}

// Clears stdin after getting input.
void flushinput() {
    char c;
    while ((c = gchar()) != '\n' && c != EOF);
}

// A node in a linked list
typedef struct Node {
    struct Node *next;
    char *todo;
    int key;
} Node;

// Initializing a node
Node *init_node() {
    Node *p = malloc(sizeof(Node));
    p->next = NULL;
    return p;
}

// A Linked list
typedef struct List {
    Node *head;
    Node *tail;
    char *filename;
} List;

void getinput(List *list, char *line) {

    char *lp = line;
    char c;
    while ((c = gchar()) != '\n')
        *lp++ = c;

    *lp++ = c;
    *lp = '\0';
}

// Initializing a linked list
void init_list(List *list) {
    Node *head = NULL;
    Node *tail= NULL;
};

// Checks for empty list
bool empty(List *list) {
    return list->head == NULL;
}

// searches a list for provided key 
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

// if element deleted, reshuffles keys so that they are numbered correctly
void updatekeys(List *list) {
    if (empty(list))
        return;

    int key = 1;
    for (Node *p = list->head; p != NULL; p = p->next) 
        p->key = key++;
}

// Length of a string, needed for malloc to set aside enough space in memory
size_t stringlen(const char *s) {
    const char *p = s;
    while (*p) p++;
    return p - s;
}

// Write update to the db
void write_to_db(List *list, char *filename) {
    int fd = open(filename, O_WRONLY | O_TRUNC);

    for (Node *p = list->head; p != NULL; p = p->next) 
        write(fd, p->todo, stringlen(p->todo));

    close(fd);
}

// Insert a new node into the list
void insert(List *list, char *todo) {
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
    p->todo = malloc(stringlen(todo) + 1);  // Allocate enough mem for the str
    char *lp = p->todo;
    while (*todo)
        *lp++ = *todo++;
}

// Deleting a node from the list
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

// Print the list to stdout
void printlist(List *list) {
    if (empty(list))
        return;

    Node *p = list->head;
    while (p != NULL) {
        printf("%d - %s", p->key, p->todo);
        p = p->next;
    }
}

// reads db when program initially opens, creates list out of db file
void read_from_db(List *list, char *filename) {
 
    int fd = open(filename, O_RDONLY | O_CREAT, 0644);
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
    close(fd);
}

int main() {
    
    char *filename = "./poop.txt";

    List list;
    init_list(&list);
    read_from_db(&list, filename);

    while (1 == 1) {
        system("clear");
        printf("C what you have to do\n\n"
           ">> Press 'a' to add to the list\n"
           ">> Press 'd' to delete from the list\n"
           ">> Press 'e' to exit the application\n"
           "_____________________________________________________________________________\n\n");

        printlist(&list);
        printf("\n\n"); 
        char c = gchar();
        flushinput();

        if (c == 'a') {
            printf("Enter what you need to do\n\n");
            char line[256];
            getinput(&list, line);
            insert(&list, line); 
            write_to_db(&list, filename);
        }
        else if (c == 'd') {
            printf("Enter the number you wish to delete\n\n");
            char n = gchar();
            flushinput();
            delete(&list, n);
            write_to_db(&list, filename);
        }
        else if (c == 'e') {
            break;
        }
    }
    return 0;
}
