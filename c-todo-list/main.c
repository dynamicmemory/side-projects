#include <inttypes.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdbool.h>
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

// sole purpose is for malloc'ing a new string for a todo 
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
    
    return malloc(slen(buffer) + 1);  // do i need the 1? did i terminate strings?
}

void insert_from_db(List *list, char *todo) {
    Node *p = (Node*)malloc(sizeof(Node));
    printf("%s\n", todo);
    char buffer[256];
    char *c = p->todo;
    p->next = NULL;
    while (*todo != '\n') {
        *c = *todo;
        c++, todo++;
    } 
    *c = *todo;

    // p->todo = buffer;
    // p->todo = malloc(sizeof(slen(buffer) + 1));
    // printf("%s this is the malloc line",  p->todo);

    if (list->head == NULL) {
        list->head = p;
        list->tail = p;
    }
    else {
        // p->next = list->tail;
        // list->tail = p;
        list->tail->next = p;
        list->tail = p;
    }
    int count = 1;
    Node *q = list->head;
    while (q->next != NULL) {
        count += 1;
        q = q->next;
    }

    list->tail->key = count;
}

// This and insert_from_db need to flow better with getinput and insert???
void read_db(List *list) {
    int fd = open(list->filename, O_RDONLY); // 3rd param is permissions, dont need here
    char buffer[BUFSIZ];
    int c;
  
    while ((c = read(fd, buffer, 1)) > 0)
        ;
    printf("%s\n", buffer);   
    char tempBuffer[256];
    char *p = tempBuffer;
    char *bp = buffer;
    while (*bp != EOF) { 
        if (*bp == '\n') {
            *p = *bp;
            printf("%s\n", tempBuffer);
            insert_from_db(list, tempBuffer);
            bp++;
            p = tempBuffer;
        }
        else {
            *p = *bp;
            p++, bp++;
        }
    }
    close(fd);
}

void insert(List *list) {
    Node *p = (Node*)malloc(sizeof(Node));

    p->next = NULL;
    char *lp = p->todo;
    char c;
    while ((c = gchar()) != '\n') {
        *lp = c;
        lp++;
    }
    *lp++ = c;
    *lp = '\0';

    if (list->head == NULL) {
        list->head = p;
        list->tail = p;
    }
    else {
        // p->next = list->tail;
        // list->tail = p;
        list->tail->next = p;
        list->tail = p;
    }

    int count = 1;
    Node *q = list->head;
    while (q->next != NULL) {
        count += 1;
        q = q->next;
    }
    p->key = count;
}

bool empty(List *list) {
    return list->head == NULL;
}

Node *search(List *list, int key) {
    Node *p = list->head;

    if (p == NULL)
        return NULL;

    while (p != NULL && p->key != key) {
        p = p->next; 
    }

    if (p == NULL)
        return NULL;
    else 
        return p;
}

void delete(List *list, char key) {
    key = key - '0';

    Node *p = search(list, key);

    if (p != NULL) {
        Node *q = list->head;

        if (p == q) {
            list->head = list->head->next;
            if (list->tail == q)    // solo check for tail == head 
                list->tail = q->next;
        }
        else {
            while (q->next != p)
                q = q->next;

            q->next = p->next;
            if (list->tail == p)
                list->tail = q;
        }
        // free(p->todo);
        free(p);
    }
}

void write_to_db(List *list) {
    if (empty(list))
        return;

    int fd = open(list->filename, O_WRONLY | O_TRUNC);

    Node *p = list->head;
    while (p != NULL) {
        write(fd, p->todo, slen(p->todo));
        p = p->next;
    }
    close(fd);
}

void update_keys(List *list) {
    if (empty(list))
        return;

    Node *p = list->head;
    int count = 1;
    while (p != NULL) {
        p->key = count;
        count += 1;
        p = p->next;
    }
}

void print_list(List *list) {
    if (empty(list))
        return; 

    Node *p = list->head;
    while (p != NULL) {
        printf("%d - %s", p->key, p->todo);
        p = p->next;
    }
}

void flushbuffer() {
    char c;
    while ((c = gchar()) != '\n' && c != EOF) ;
}

int main() {
    char filename[] = "database.txt"; 

    List list;
    init_list(&list, filename);
    read_db(&list);

    while (1 == 1) {
        system("clear");
        print_list(&list);  
        printf("\nEnter a Command\n\n");
        char c = gchar();
        flushbuffer();

        if (c == 'a') {
            printf("\nWrite your todo\n\n");
            insert(&list);

        }
        else if (c == 'd') {
            printf("\nEnter the number you wish to delete\n\n");
            char key = gchar();
            flushbuffer();
            delete(&list, key);
            update_keys(&list);
        }
    }
    return 0;
}


