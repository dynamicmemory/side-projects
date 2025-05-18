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

void read_to_list() {
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
    if (fd < 0) {
        perror("open");
        return;
    }

    char buffer[BUFSIZ];
    int filebytes = read(fd, buffer, BUFSIZ);
    buffer[filebytes] = '\0';

    close(fd);

    int currentline = 1;
    char *start = buffer;
    char *end = buffer;
    
    int out = open(filename, O_WRONLY | O_TRUNC, 0);
    if (out < 0) {
        perror("open for write");
        return;
    }

    while (*end) {
        if (*end == '\n') {
            if (currentline != linenumber)
                write(out, start, end - start + 1);

            currentline++;
            end++;
            start = end;
        }
        else {
            end++;
        }
    }
    close(out);
}

void flush_input() {
    int c;
    while ((c = gchar()) != '\n' && c != EOF);
}

int main(int argc, char *argv[]) {
    // List list;
    // init_list(&list);

    if (argc > 1) {
        // readfile(argv[1]);
        while (1 == 1) {
            system("clear");
            readfile(argv[1]); 

            printf("\n>> ");
            char n = getchar();
            flush_input();

            if (n == 'a') {
                printf("write what you want >> ");
                wtf(argv[1]);
            }
            else if (n == 'd') {
                printf("\n\nEnter line number to delete >> ");
                int b = getchar();
                flush_input();
                delete(argv[1], b);
            }
            else 
                ;
        }
    }
    return 0;
}

