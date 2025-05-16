#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

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

// Reads a file that is input via command line... probably in general too actually 
void readfile(char *filename, char *file) {
    int fd = open(filename, O_RDONLY, 0);
    int c;
    while ((c = read(fd, file, BUFSIZ)) > 0)
        write(1, file, c);
    close(fd);
}

int main(int argc, char *argv[]) {

    char filename[] = "database.txt";

    if (argc > 1)
        readfile(filename, *argv);
    // int fd = open(filename, O_RDONLY, 0);

    // int c;
    
    // while ((c = read(fd, *argv, BUFSIZ)) > 0)
    //     write(1, *argv, c);
    // char c;
    // while ((c = gchar()) != EOF)
    //     pchar(c);

    // close(fd);
    return 0;
}

