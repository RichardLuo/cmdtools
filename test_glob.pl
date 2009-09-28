#!/usr/bin/perl -w
################################################################
# test_glob.pl
# Richard Luo
# 2008-08-26
################################################################
use strict;
use warnings;

use Shell qw(cat ls find diff mkdir svn);
my $sh = Shell->new;


my $src_dir = "src";
my $inc_dir = "include";
my $lib_dir = "lib";

# my @make_files = glob "Makefile";


my @make_files = $sh->find(". -name Makefile");

if (!@make_files) {
    die "no make files here!!";
}

foreach (@make_files) {
    print;
}

