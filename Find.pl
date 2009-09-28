#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd;

use File::Find;

my $search_pattern=$ARGV[0];
my $file_pattern  =$ARGV[1];

find(\&d, cwd);

sub d {

  my $file = $File::Find::name;

  $file =~ s,/,\\,g;

  print 'file is:' . "$file" . "\n";

  return unless -f $file;
  return  unless $file =~ /$file_pattern/;

  open F, $file or print "couldn't open $file\n" && return;

  while (<F>) {
    if (my ($found) = m/($search_pattern)/o) {
      print "found $found in $file\n";
      last;
    }
  }

  close F;
}
