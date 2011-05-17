#!/usr/bin/perl
#
#	FEEDGB.pl -- takes a list of tab separated posts and the site it came from and adds to the a number of
#	Gigablast queues, to cause the post to be crawled, and the site to be deep crawled once and then addded
#	to the sitedb.
#
#	Usage
#		perl feedgb.pl [inputfile]
#
#	Inpufile Format:
#			post<TAB>site
#		either can be optional, but the tab needs to be there to pick up the optional site
#
#	History:
#		(mm) -- 12/16/2008 first version
#

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use LWP::Simple;
use URI::Escape;
use URI::Escape qw(uri_escape_utf8);

#use Text::xSV;
#my $csv = new Text::xSV;
my $gb  = "http://66.231.188.220:8000";


my $nl = "\n";

$ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

sub Null_str($) { 
	my $s = shift; 
	return !$s && $s eq "" 
}

sub esc_url($) {
	my $url = shift;
	$url =~ s|^http:(//)?||;
	$url = 'http://' . $url;
	$url = uri_escape_utf8($url);
	return $url;
}

sub add_post ($) {
	my $p = shift;

	return if Null_str($p);
	$p = esc_url $p;
	# post crawled

	my $response = $ua->get('$gb/addurl?u' .
		$p . '&ufu=&ufd=&c=watchlist&p=31&force=1&dr=36&strip=1&spiderLinks=1');

	if (!$response->is_success) {
		print "add_post: crawl failed: ", $response->status_line, $nl;
	}
}

sub add_site ($) {
	my $s = shift;
	$s = esc_url $s;

	return if Null_str($s);
	# classify site as valid blog
	my $req = POST '$gb/master/sitedb?c=mainRebuild&pwd=bananarama&master=0',
			[ c => "mainRebuild", cast=>0, cmnt=> '', f => 36, lookupsite => '', master => 0,
			  pwd => "bananarama", quality=>'', spambits=>0, u=>$s, usr => '', x=>'' ];

	if (!$ua->request($req)->is_success) {
		print "add_site classify failed: ", $ua->request($req)->status_line, $nl;
	}

	# one time site deep crawling
	my $response = $ua->get('$gb/addurl?u=' .
		$s . "c=watchlist&p=30&force=1&dr=36&strip=1&spiderLinks=1");

	if (!$response->is_success) {
		print "add_site, deep crawl failed: ", $response->status_line, $nl;
	}


}

#$csv->read_header();
# Make the headers case insensitive
#foreach my $field ($csv->get_fields) {
#if (lc($field) ne $field) {
    #$csv->alias($field, lc($field));
#}
	    
      while (<>) {
		next if /^$/ || /^#/;
		chomp;
		($post, $site) = split "\t";
		$post = uri_unescape($post);
		$site = uri_unescape($site);
		print "adding post=$post, site=$site", $nl;
		add_post $post;
		add_site $site;
      	}
