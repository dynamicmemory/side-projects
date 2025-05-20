// TODO: Implement tail and replace all p->prev with p = tail p->next


#include <endian.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

typedef struct Node {
        struct Node *next;
        struct Node *prev;
        int key;
        char todo[200];
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
    while (q->prev != NULL)       // TODO: implement tail to stop this wind back
        q = q->prev;
    while (q->next != NULL) {
        q = q->next;
        linenumber++;
    }
    list->head->key = linenumber;

}

void insert_from_file(List *list, char *line) {
    // Creating the new node and assigning vars
    Node *p = (Node*) malloc(sizeof(Node));
    char *lp = p->todo;
    p->next = NULL;
    p->prev = NULL;
    // Writing the string to the todo member 
    char c;
    while ((c = *line) != '\n') {
        *lp = c;
        lp++;
        line++;
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
    while (q->prev != NULL)       // TODO: implement tail to stop this wind back
        q = q->prev;
    while (q->next != NULL) {
        q = q->next;
        linenumber++;
    }
    list->head->key = linenumber;

}

// Reads a file that is input via command line... probably in general too actually 
void readfile(List *list, char *filename) {
    int fd = open(filename, O_RDONLY, 0);

    char buffer[BUFSIZ];
    int c;
    while ((c = read(fd, buffer, BUFSIZ)) > 0) ;
        // printf("%c",c);
        // write(1, buffer, c);
    
    char line[200];
    char *lp = line;
    char *end = buffer;
    while (*end != EOF) {
        if (*end == '\n') {
            *lp = *end;
            insert_from_file(list, line);
            end++;
            lp = line;
        }
        else { 
            *lp = *end;
            end++;
            lp++;
        }
    }
    close(fd);
}

void update_db(List *list, char *filename) {
    if (list->head == NULL)
        return;

    Node *p = list->head;
    while (p->prev != NULL) {
        p = p->prev;
    }

    int fd = open(filename, O_WRONLY | O_TRUNC, 0);

    while (p != NULL) {
        char *tp = p->todo;
        while (*tp != '\n') {
            write(fd, tp, 1);
            tp++;
        }
        write(fd, tp, 1);
        p = p->next;
    }

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

// void delete(char *filename, int linenumber) {
    // linenumber = linenumber - '0';

    // int fd = open(filename, O_RDWR, 0);
//     if (fd < 0) {
//         perror("open");
//         return;
//     }
//
//     char buffer[BUFSIZ];
//     int filebytes = read(fd, buffer, BUFSIZ);
//     buffer[filebytes] = '\0';
//
//     close(fd);
//
//     int currentline = 1;
//     char *start = buffer;
//     char *end = buffer;
//
//     int out = open(filename, O_WRONLY | O_TRUNC, 0);
//     if (out < 0) {
//         perror("open for write");
//         return;
//     }
//
//     while (*end) {
//         if (*end == '\n') {
//             if (currentline != linenumber)
//                 write(out, start, end - start + 1);
//
//             currentline++;
//             end++;
//             start = end;
//         }
//         else {
//             end++;
//         }
//     }
//     close(out);
// }
//
void flush_input() {
    int c;
    while ((c = gchar()) != '\n' && c != EOF);
}

void delete(List *list, int n) {
    n = n - '0';

    if (list->head == NULL) 
        return;
    
    Node *p = list->head;           // head is end of list so we have to work backwards
    while (p != NULL && p->key != n) {
        p = p->prev;
    }

    if (p == NULL)
        return;

    if (p == list->head) {
        list->head = list->head->prev;
        if (list->head != NULL)
            list->head->next = NULL;
    }
    else {
        if (p->prev != NULL) 
            p->prev->next = p->next;
        if (p->next != NULL) 
            p->next->prev = p->prev;
    }

    // free(p->todo);      // probably gonna need this for the future
    free(p);
}

void print_list(List *list) {
    if (list->head == NULL)
        return;

    Node *p = list->head;

    while(p->prev != NULL) 
        p = p->prev;

    while (p != NULL) {
        printf("%d - %s", p->key, p->todo);
        p = p->next;
    }
    printf("\n");
}

void adjust_indexes(List *list) {
    if (list->head == NULL)
        return;
    Node *p = list->head;
    while (p->prev != NULL) 
        p = p->prev;

    int index = 1;
    while (p != NULL) {
        p->key = index;
        index++;
        p = p->next;
    }
}

void clean(List *list) {
    system("clear");
    printf("C what you have to do\n\n"
           ">> Press 'a' to add to the list\n"
           ">> Press 'd' to delete from the list\n"
           ">> Press 'e' to exit the application\n"
           "_____________________________________________________________________________\n\n");
    print_list(list);
}

int main(int argc, char *argv[]) {

    List list;
    init_list(&list);

    readfile(&list, argv[1]);
    while (1 == 1) {

        clean(&list);
        
        char c = gchar();
        flush_input();

        if (c == 'a') {
            printf("Enter what you need to do\n\n");
            insert(&list);
            update_db(&list, argv[1]);
        } 
        else if (c == 'd') {
            printf("Enter the todo number you wish to remove\n\n");
            char n = gchar();
            flush_input();
            delete(&list, n);
            adjust_indexes(&list);
            update_db(&list, argv[1]);
            
        }
        else if (c == 'e') {
            break;
        }
        else {
            ;
        }
    }
    return 0;
}

