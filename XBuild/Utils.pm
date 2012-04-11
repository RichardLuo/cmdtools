package Utils;

use strict;

sub print_array;
sub has_main_entry;

################
# for debug array.
################################################################
sub print_array {
  foreach (@_) {
    print $_, "\n";
  }
}

################
# to check whether the code has 'main' func definition.
# $1: local source file name
################################################################
sub has_main_entry {
  my $file = shift;
  chomp $file;
  open(FILE, "< $file") or die "can not open local $file";
  my $contents = <FILE>;
  if ($contents =~ /^\s*(\bint\b|\bvoid\b|)\s*(main|ACE_TMAIN)\s*\(.*?\)/m) {
    print "Note: $file have main func definition \n";
    return 1;
  }
  return 0;
}

1;
