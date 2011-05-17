#! /usr/bin/env perl
#
#  hier [-b basename] [-n files-per-directory ] [-s suffix] [-d start-dir-number] [-x]
#
#
#   Hier - move flat directory structures with lots of files into subdirectories based on number of files per dir 
#   desired.
#   moves all files in the current directory which match the suffix to directories numbered from start-dir-number, 
#   creating new directories as needed, so that only files-per-directory files are put in each.
#   -x prints the shell commands to do it without actually doing the moves/creates.
#   -q quiet
#   -a don't use a pattern (match every file which isn't a directory)
#   History:
#	marc@persefon.com -- 3/15/2009 created.
#
use Getopt::Std;
getopts("b:n:s:d:xqa");

$basedir = $opt_b || "restore";
$perdir = $opt_n || 300;
$suffix = $opt_s || "jpg";
$startd = $opt_d || 1;

sub mv {

    $a = shift;
    $b = shift;
    rename $a, "$b/$a" || warn "unable to rename $a to $b/$a";
}

sub mkdir 
{
    my $a = shift;
    CORE::mkdir $a;
}

sub dof
{
    my $f = shift;
    my	$b = shift;
    my	$c = shift;

    if (!$opt_q) {
	my $bb = "'$b'";
	my $cc = "'$c'" if $c;
	print "$f $bb $cc\n";
    }
    if (!$opt_x) {
	&{$f}($b, $c);
    }
}

@files = `ls | sort -n`;

$cnt = 1;

for $f (@files) {
    chomp $f;
    next if -d $f || (!$opt_a && $f !~ m/.*\.$suffix/o);

    $dirn = int($cnt / $perdir) + $startd;
    $filen = ($cnt - 1) % $perdir + 1;
    if ($filen == 1) {
	$DIR = $basedir . sprintf("%03d", $dirn);
	dof("mkdir", $DIR, "");
    }
    dof("mv",$f, $DIR);
    $cnt++;
}
