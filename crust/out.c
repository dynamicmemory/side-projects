#include <stdio.h>


int sum(int a, int b) {
return a + b;
}
int main() {
const int x = 10;
const int y = 20;
int z = sum(x, y);
printf("%d\n", sum(z, 1));
}