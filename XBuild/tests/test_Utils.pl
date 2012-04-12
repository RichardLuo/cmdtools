#!/usr/bin/perl -w
################################################################
# file:   test_Utils.pl
# author: Richard Luo
# date:   2012-04-12 16:21:44
################################################################
use strict;
use warnings;

use XBuild::Utils;


# print  "ARGV:$ARGV[0] \n";

foreach (@ARGV) {
  my $tmp = $_;
  if (Utils::has_main_entry($tmp)) {
    print "+\$_:$_ \n";
    print "[$_] has main entry \n";
    print "[$tmp] has main entry \n";
  }
}
