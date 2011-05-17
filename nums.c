# include <stdio.h>
typedef struct num	{
	int	digit;
	struct num	*next;
	struct num	*last;
} num;

num	Numbers[11];
num	*SelectFrom = Numbers;
int	TotalCount;

typedef unsigned int	u_int;
u_int	NumMask;
u_int	ShiftVal[10];

void initNumbers()
{	
	int	i;
	num	*this = Numbers;
	int	sz = (sizeof Numbers/sizeof Numbers[0]);


	NumMask = (1023 << 1) + 1;
	for (i = 0; i < 10; i++)
		ShiftVal[i] = 1 << i;

	return;
}

printNumbers() {
	num *n = Numbers;

	int	i;
	for (i = 0; i < 10; i++) {
			printf("%d ", i);
	}
	return;
			
	for (;n; n = n->next) {
		printf("%d ", n->digit);
	}
}

# define  	in_m(dig) 	(NumMask & ShiftVal[dig])
# define	ins_m(dig)	(NumMask |= ShiftVal[dig])
# define	del_m(dig) 	(NumMask &= ~ShiftVal[dig])

inline int	n_n(int dig) {
	dig++;
	while (!in_m(dig))
		dig++;
	return dig;
}


void ins(num *this) {
	num *next, *last;

	if (this->last)
		this->next = this->last->next;
	else
		this->next = 0;
	if (this->next)
		this->next->last = this;
	return;
	this->next = next;
	this->last = last;
	if (next) 
		next->last = this;
	if (last) 
		last->next = this;
	if (next == SelectFrom)
		SelectFrom = this;

}
void del(num *n) {
	if (n->next)
		n->next->last = n->last;
	if (n->last)
		n->last->next = n->next;
	if (n == SelectFrom) 
		SelectFrom = n->next;
}
typedef unsigned long ll;
ll		Delta;
ll		DeltaGen;
ll	 	LastGen;
ll		Gen;

ll	IncCnt;
ll	InIncCnt;


inline int 	increment(int *mask, int *dig) {
	//InIncCnt++;
	while (!(NumMask & *mask)) {
		//IncCnt++;
		(*dig)++;
		(*mask) <<= 1;
	}
}
void runNDigs(int, int);

void runDigs(int left, int zerorun) {
	int	deld = 0;
	int	dig;
	void	(*run)(int, int);

	if (left == 0) {
		TotalCount++;
		# ifdef PVALS
		printf("%lu, \n", Gen);
		if (Delta < (Gen - LastGen)) {
			Delta = Gen - LastGen;
			DeltaGen = LastGen;
		}
		LastGen = Gen;
		# endif
		return;
	}

	int mask = 1;
	dig = 0;
	for (;;) {
		/* find next empty digit w/ sentinel */
		# ifdef INC
		increment(&mask, &dig);
		# else
		while (!(NumMask & mask)) {
			dig++;
			mask <<= 1;
		}
		# endif
		if (dig > 9)
			return;

		/* delete a number, and do for all otherdigs; */
		if (!(zerorun &= !dig)) {
			del_m(dig);
			run = runNDigs;
		}
		else {
			run = runDigs;
		}
		Gen = 10 * Gen + dig;
		(*run)(left - 1, zerorun);
		Gen /= 10;

		if (!zerorun)
			ins_m(dig);
		mask <<= 1;
		dig++;
	}
}

void runNDigs(int left, int zerorun) {
	int	deld = 0;
	int	dig;

	if (left == 0) {
		TotalCount++;
		# ifdef PVALS
		printf("%lu, \n", Gen);
		if (Delta < (Gen - LastGen)) {
			Delta = Gen - LastGen;
			DeltaGen = LastGen;
		}
		LastGen = Gen;
		# endif
		return;
	}

	int mask = 1;
	dig = 0;
	for (;;) {
		/* find next empty digit w/ sentinel */
		# ifdef INC
		increment(&mask, &dig);
		# else
		while (!(NumMask & mask)) {
			dig++;
			mask <<= 1;
		}
		# endif
		if (dig > 9)
			return;

		/* delete a number, and do for all otherdigs; */
		del_m(dig);
		Gen = 10 * Gen + dig;
		runNDigs(left - 1, zerorun);
		Gen /= 10;

		ins_m(dig);
		mask <<= 1;
		dig++;
	}
}
int	main()
{
	int	i;

	/*setbuf(stdout, NULL);*/
	initNumbers();
	/*printNumbers();
	printf("\n");
	*/
	
	runDigs(10, 1);
	printf("TotalCount %d, biggest diff == %llu between %llu and %llu\n", 
		TotalCount, Delta, DeltaGen, DeltaGen + Delta);

	printf("IncCnt %d, avg %g\n", IncCnt, (double)IncCnt/InIncCnt);
	return 0;
}

