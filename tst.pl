use Test::Deep;

my %v = ('a'=>4, 'b'=>2, 'a.b.c'=>1);
my %y = %v;

sub passit {
	my %v = @_;

	return %v;
}

print "fail 1\n" if !eq_deeply \%v, \%y;

%x = passit %v;
print "fail 2\n" if !eq_deeply \%x, \%y;

$v{'a'} = 10;
print "fail 3\n" if eq_deeply \%v, \%y;
print done;
