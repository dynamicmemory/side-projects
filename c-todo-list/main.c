#include <stdio.h>
#include <stdlib.h>

#define FNAME "database.txt"     //TODO change this to an actual db

char *get_line(char *line) {
    char c;
    char *lp = line;

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

// Probably going to have to approach this from a different angle
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

    fclose(rp);
    printf("%s", list); 

    FILE *wp = fopen(filename, "w");
    char *llp = list;
    while (*llp != '\0') {
        if (*llp == '\n')
            line -= 1;
        if (line == 0) {
            printf("Line no: %d", line);
            while (*llp != '\n') {
                printf("inside the while %c \n",*llp);
                llp++;
            }
        }
        else {
            putc(*llp, wp);
            llp++;
        }
    }


    fclose(wp);
}

int main(int argc, char *argv[]) {
   
    read_list(FNAME);
    append_list(FNAME);
    read_list(FNAME);
    delete_line(FNAME, 5);
    read_list(FNAME);
    return 0;
}
