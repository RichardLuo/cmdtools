#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(touch);

my $sh = Shell->new;

my $subfix = shift;
my $number = shift;
my $prefix = shift;

my $filename = 0;

for (;$filename < $number; ++$filename) {
	$subfix =~ s/^\.+//;
	my $composed_file = "$prefix$filename\.$subfix";
	print "create file, name is [$composed_file] \n"; 
	$sh->touch("$composed_file");
}

