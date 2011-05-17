# include <stdio.h>
int fib(int n) {
    if (n <= 1) { return 1; }
    int last = 1;
    int pen = 1;
    int i;
    for (i = 1; i < n; i++) {
	int both = last + pen;
	pen = last;
	last = both;
    }
    return last;
}
main(int argc, char**argv) {

    int n = 0;
    if (argc >= 2) 
	n = atoi(argv[1]);
    printf("fib(%d) = %d\n", n, fib(n));
}

