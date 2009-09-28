#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(ls find diff nm);

my $demangle = ' -C ';
my $sh = Shell->new;

die "usage: \n\\t mygensymbol.pl  [directory name] \n" if $#ARGV != 0;

my $find_params = '-name *.[oa]';
my $top_dir = shift;

my @find_files = $sh->find(" $top_dir ".$find_params);

foreach (@find_files) {
  chomp;
  if (-e $_) {
	my $filename = $_;
	if ($filename =~ /libACE_la\-ACE.o/) {
	  print "#### process $_ \n";
	}
#	my @nm_out = $sh->nm($noDemangle.$_);
#	my @nm_out = $sh->nm($demangle.$filename);

	my @nm_out = nm(' '.$filename);

	foreach (@nm_out) {
	  #			next unless /^\w+\s+([tT])\s+(\w+)\s*$/;
	  next unless /^\w+\s+([a-zA-Z])\s+(\w+)\s*$/;
	  printf "%-40s %-50s %-5s \n", $2, $filename, $1;
	}
  }
}

