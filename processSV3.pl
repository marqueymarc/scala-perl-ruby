#!/usr/bin/perl
# Takes the output of 2
#	blog SV1 v1 SV2 v2 SV3 v3
# and puts each blog SV v on its own line.  
# Also breaks down each SV into all its components as well
#	History:
#		(mm) -- 1/00/09 first version
#

	    $nl = "\n";
	    $line = 1;
	    
	sub print_blog;
	my %blog, %bvotes;
	print "Blog,SV,v$nl";
	while (<>) {
		# skip the header line and comments and blank lines
		next if $line++ == 1 || /^$/ || /^#/;
		chomp;
		@row = split ",";

		$blog = shift @row;
		# pick up paurs of category/scores until out.
		while ($cat = shift @row) {
			$score = shift @row;
			print "$blog,$cat,$score$nl";
			#print_blog $blog, $cat, $score;
		}
	}

# print a blog cat score entry, 
#  repeating for each parent category
sub print_blog {
	($blog, $cat, $score) = @_;

	while ($cat) {
		print "$blog,$cat,$score$nl";
		# take out a subcategory
		$cat =~ s/\.[^.]*$//;
		last if ($cat !~ /\./);
	}
}
