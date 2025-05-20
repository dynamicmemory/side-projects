#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "node.h"

// If i end up writing my own printf and server the stdio connection.
// #define BUFSIZ 8192
// #define NULL ((void *)0)
// #define EOR (-1)

typedef struct List {
    Node *head;
    Node *tail;
    char *filename;
} List;

void init_list(List *list, char *filename) {
    list->head = NULL;
    list->tail = NULL;
    list->filename = filename;
}

// Pure experiment


char gchar() {
    char c;
    if (read(0, &c, 1) == 1)
        return c;
    else 
        return EOF;
}

size_t slen(const char *s) {
    const char *p = s;
    while (*p) p++;
    return p - s;
}

// get cli input, this could be bug prone in future fo shaw
char *getinput() {
    char c;
    char buffer[256];
    char *bp = buffer;

    while ((c = gchar()) != '\n') {
        *bp = c;
        bp++;
    }
    *bp = c;
    
    return malloc(slen(buffer) + 1); 
}

char read_db(List *list) {
    int fd = open(list->filename, O_RDONLY); // 3rd param is permissions, dont need here
    char buffer[BUFSIZ];
}

void insert(List *list, int flag) {
    Node *p = (Node*)malloc(sizeof(Node));
    if (flag != 0) 
        p->todo = getinput();
    else 
        p->todo = // when reading from db

}


int main() {
    char filename[] = "database.txt"; 

    List list;

    return 0;
}


