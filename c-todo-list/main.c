#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

typedef struct Node {
        struct Node *next;
        struct Node *prev;
        int key;
        char todo[100];
} Node;

typedef struct List {
        Node *head;
        // Node *tail;
} List;

void init_list(List *list) {
    list->head = NULL;
    // list->tail = NULL;
}

// Read from stdin
int gchar(void) {
    char c;
    if (read(0, &c, 1) == 1)   // stdin, ref to what is being red, size
        return c;
    else 
        return EOF;
}

// Read to stdout
void pchar(char c) {
    write(1, &c, 1);   // stdout, ref to what is being wrote, size
}

void insert(List *list) {
    // Creating the new node and assigning vars
    Node *p = (Node*) malloc(sizeof(Node));
    char *lp = p->todo;
    p->next = NULL;
    p->prev = NULL;
    
    // Writing the string to the todo member 
    char c;
    while ((c = gchar()) != '\n') {
        *lp = c;
        lp++;
    }
    *lp = '\n';

    // checks for where it is inserted 
    if (list->head == NULL) 
        list->head = p;
    else {
        list->head->next = p;
        p->prev = list->head;
        list->head = p;
    }
 
    // assign a key number to the node
    int linenumber = 1;
    Node *q = list->head;
    while (q->prev != NULL)
        q = q->prev;
    while (q->next != NULL) {
        q = q->next;
        linenumber++;
    }
    list->head->key = linenumber;

}

// write list to db
// read from db
// search node - delete helper
// delete node 
// print list 

// Reads a file that is input via command line... probably in general too actually 
void readfile(char *filename) {
    int fd = open(filename, O_RDONLY, 0);

    char buffer[BUFSIZ];
    int c;
    while ((c = read(fd, buffer, BUFSIZ)) > 0)
        write(1, buffer, c);
    close(fd);
}

void wtf(char *filename) {
    int fd = open(filename, O_RDWR, 0);

    char buffer[BUFSIZ];
    char c;

    lseek(fd, 0L, 2);
    while ((c = gchar()) != '\n') 
        write(fd, &c, 1);
    write(fd, &c, 1);    // write the new line
}

void delete(char *filename, int linenumber) {
    linenumber = linenumber - '0';
    int fd = open(filename, O_RDWR, 0);
    char buffer[BUFSIZ];
    int c;
    int currentline = 1;

    while ((c = read(fd, buffer, BUFSIZ)) != EOF) {
        if (c == '\n')
            currentline++;

        if (currentline == linenumber)
            ;
        else 
            write(fd, buffer, c);
    }
}

int main(int argc, char *argv[]) {
    List list;
    init_list(&list);

    if (argc > 1) {
        readfile(argv[1]);

        printf("enter line number to del");
        char n;
        while ((n = gchar()) != '\n');
        delete(argv[1], n);

        printf("\n");
        // wtf(argv[1]);
        readfile(argv[1]);
        
    }
    return 0;
}

