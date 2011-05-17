#!/usr/bin/perl
#
#	Take the mechanical turn data and break out the various votes into 
#	individual rows
#	History:
#		(mm) -- 12/16/2008 first version
#

$nl = "\n";
$cat_pos = 27;
	    
      while (<>) {
		next if /^$/ || /^#/;
		chomp;
		@row = split ",";
		$votes = $row[$cat_pos];
		@votes = split /\|/, $votes;
		for $i (@votes) {
			# replace broken out category in the original input rec
			# and output
			$row[$cat_pos] = $i;
			print join (",", @row), $nl;
		}
      	}
