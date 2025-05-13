#include <stdio.h>
#include <stdlib.h>

#define FNAME "database.txt"     //TODO change this to an actual db

void flush_input() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

char *get_line(char *line) {
    char c;
    char *lp = line;
    printf(">>");
    while ((c = getchar()) != '\n') {
        *lp = c;
        lp++;
    }
    *lp++ = '\n';
    *lp = '\0';

    return line;
}

void read_list(char *filename) {
    // system("clear");
    FILE *fp = fopen(filename, "r");
    int c;

    while ((c = getc(fp)) != EOF) 
        putc(c, stdout);

    fclose(fp);
}

void append_list(char *filename) {
    FILE *fp = fopen(filename, "a");
    char c; 
     
    char line[100];
    char *lp = get_line(line);

    for (; *lp; lp++) {
        putc(*lp, fp);
    }

    fclose(fp);
}

void delete_line(char *filename, int line) {
    FILE *rp = fopen(filename, "r");

    char c;
    int n = 1; 

    char list[10000];
    char *lp = list;
    while ((c = getc(rp)) != EOF)  {
        *lp = c;
        lp++;
    }
    lp = list;
    fclose(rp);

    printf("Deleting line number: %d\n", line);

    FILE *wp = fopen(filename, "w"); 
    int current_line = 1;
    while (*lp != '\0') {
        if (*lp == '\n') 
            current_line++;
        if (line == current_line)
            lp++;
        else { 
            putc(*lp, wp);
            lp++;
        }
    }
    fclose(wp);
}

int get_int(char c) {
    int n = c - '0';
    return n;
}


int main(int argc, char *argv[]) {
    char c; 
    while (c != EOF) {
        system("clear");
        read_list(FNAME);
        c = getchar();
        flush_input();
        if (c == 'a') {
            system("clear");
            read_list(FNAME);
            append_list(FNAME);
        }
        else if (c == 'd') {
            system("clear");
            read_list(FNAME);
            printf("Which line would you like to delete\n");
            char d;
            d = getchar();
            flush_input();
            d = get_int(d);
            printf("d = %c\n",d);
            delete_line(FNAME, d);
        }
        else if (c == 'e') 
            c = EOF;
        else
            printf("Type a to add and d to delete\n");
    }
    // printf("Reading list\n");
    // read_list(FNAME);
    // append_list(FNAME);

    // printf("Reading list\n");
    // read_list(FNAME);
    // printf("Reading list\n");
    // delete_line(FNAME, 5);
    // printf("Reading list\n");
    // read_list(FNAME);
    return 0;
}
