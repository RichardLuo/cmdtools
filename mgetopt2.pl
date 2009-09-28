#!/usr/bin/perl

# script is "./g"
use Getopt::Std;
%options=();
getopts("od:fF",\%options);
# like the shell getopt, "d:" means d takes an argument
print "-o $options{o}\n" if defined $options{o};
print "-d $options{d}\n" if defined $options{d};
print "-f $options{f}\n" if defined $options{f};
print "-F $options{F}\n" if defined $options{F};
print "Unprocessed by Getopt::Std:\n" if $ARGV[0];

foreach (@ARGV) {
  print "$_\n";
}
