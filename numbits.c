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
	for (i = 0; i < 10; i++) {
		NumMask |= 1 << i;
	}
		
	return;
	for (i = 0; i < sz - 1; i++) {
		this->digit = i;
		this->next = &Numbers[i+1];
		this->next->last = this;
		this = this->next;
	}
	this = &Numbers[sz - 1];
	this->next = 0;
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
typedef unsigned long	ll;
ll		Delta;
ll		DeltaGen;
ll	 	LastGen;
ll		Gen;

void runDigs(int left, int zerorun) {
	int	deld = 0;
	int	dig;

	if (left == 0) {
		TotalCount++;
		# if 0
		printf("%lu, \n", Gen);
		if (Delta < (Gen - LastGen)) {
			Delta = Gen - LastGen;
			DeltaGen = LastGen;
		}
		LastGen = Gen;
		# endif
		return;
	}

	/*
	for (dig = n_n(-1); dig < 10; dig = n_n(dig)) {
	*/
	int mask = 1;
	dig = 0;
	for (;;) {
		/* quick find next empty digit w/ sentinel */
		while (!(NumMask & mask)) {
			dig++;
			mask <<= 1;
		}
		if (dig > 9)
			return;

		/* delete a number, and do for all otherdigs; */
		if (!(zerorun &= !dig)) {
			deld = 1;
			del_m(dig);
		}
		else
			deld = 0;
		Gen = 10 * Gen + dig;
		runDigs(left - 1, zerorun);
		Gen /= 10;

		if (deld)
			ins_m(dig);
		mask <<= 1;
		dig++;
	}
}
unused() {
	num	*this, *l, *n;
	int	left;
	int	deld;
	int	zerorun;

	for (this = SelectFrom; this; this = this->next) {
		l = this->last;
		n = this->next;

		/* delete a number, and do for all otherdigs; */
		deld = 0;
		if (!(zerorun &= !this->digit)) {
			deld = 1;
			del(this);
		}
		Gen = 10 * Gen + this->digit;
		runDigs(left - 1, zerorun);
		Gen /= 10;

		if (deld)
			ins(this);
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

	return 0;
}

