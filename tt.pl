#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;

use Shell qw(cat ls find diff mkdir svn date);
print "hello wrold \n" ;
my $sh = Shell->new;
my $prefix = $sh->date(" +%Y%m%d_%S");
chop $prefix;
print $prefix;

