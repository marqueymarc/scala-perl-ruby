#!/usr/bin/perl
#
# Takes the mechanical turk output for blog classification and outputs a 
# line per blog with up to three columns of top voted categories.
#	History:
#		(mm) -- 1/08/09 first version
#
use Test::Deep;

	    $nl = "\n";
	    $line = 1;
	$blog_pos = 26;
	$votes_pos = 27;
	    
      sub cat_sort;
      sub eliminate_roots;
      sub push_votes_down;
      my %blog, %bvotes;
      while (<>) {
		next if $line++ == 1 || /^$/ || /^#/;
		chomp;
		@row = split ",";
		$blog = $row[$blog_pos];
		$votes = $row[$votes_pos];
		@votes = split /\|/, $votes;
		for $v (@votes) {
			$v =~ s/_/./g if $v !~ /Blog_does_not_exist/i;
			$blogs{$blog}{$v} += 1;
		}
      	}
	print "Blog,SV1, v1, SV2, v2,SV3, v3$nl";

	for $b (sort keys %blogs) {

		@res_votes = ("", "",  "", "", "", "");
		# copy the category/vote 
		%bvotes = push_votes_down \%{$blogs{$b}};
		%bvotes = eliminate_roots \%bvotes;

		$i = 0;
		for $v (sort cat_sort  (keys %bvotes)) {
			if ($bvotes{$v} > 1) {
				$res_votes[$i++] = $v;
				$res_votes[$i++] = $bvotes{$v};
			}
		}
		print "$b";

		# print first three pairs of category/votes
		for ($i=0; $i < 6; $i++) {
			print ",$res_votes[$i]";
		}
		print $nl;
	}
	
	
# sorts subcategories higher than the supercategory, not done tyhis way cause 
# can be inconsistent with regard to comparisons
sub cat_sort {
	{$bvotes{$b} <=> $bvotes{$a}}
}

sub test {

	%v = ('a'=>4, 'c'=>2, 'a.b.c'=>1 ) ;
	%t = push_votes_down \%v;
	%v = ('a'=>4, 'c'=>2, 'a.b.c'=>5 ) ;
	print "FAIL push_votes_down\n" if !eq_deeply \%v, \%t;

	%t = eliminate_roots \%v;
	%v = ('c'=>2, 'a.b.c'=>5 ) ;
	print "FAIL eliminate_roots\n" if !eq_deeply \%t, {'a.b.c'=> 5, 'c'=>2};

	return 1;
}


# votes at higher levels of the tree get pushed down to the leaves if present.
sub push_votes_down {
	my %v = %{ $_[0] };
	my %out;


	foreach (keys %v) {
            my $cat = $_;
	    my $vote = $v{$cat};

	    foreach (keys %v) {
		my $subc = $_;
	    	$v{$subc} += $vote if $subc =~ /^$cat\./;
	    }
	} 

	return %v;
}

# a cat isn't a supercategory of something else if nothing else includes 
# its name with a . at the end (and something else)
sub not_supercat {
	my $cat = shift;
	my $votes = shift;

	return scalar(map { $_ =~ /^$cat\./ } keys %{$votes}) == 0;

}

sub eliminate_roots {
	my %votes = %{ $_[0] };
	my %out;

	# leaf keys are ones which don't appear as supercategories
	my @leaf_keys = grep { not_supercat $_, \%votes } keys %votes;
	map { $out{$_} = $votes{$_} } @leaf_keys;

	return %out;
}
