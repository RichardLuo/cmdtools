#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd;
use strict;
use warnings;
use diagnostics;
use Shell qw(ls find diff nm);

my $demangle = ' -C ';
my $sh = Shell->new;

use File::Find;

# my $search_pattern=$ARGV[0];
# my $file_pattern  =$ARGV[1];

find(\&d, cwd);

sub d {
  my $file = $File::Find::name;

#   $file =~ s,/,\\,g;

  # return unless -f $file;
  # return  unless $file =~ /$file_pattern/;

  if ($file =~ /\w+\.(o|a)$/) {
    print 'file is:' . "$file" . "\n";

    my @nm_out = nm(' '.$file);

    foreach (@nm_out) {
      #			next unless /^\w+\s+([tT])\s+(\w+)\s*$/;
      next unless /^\w+\s+([a-zA-Z])\s+(\w+)\s*$/;
      printf "%-36s %-60s %-10s \n", $2, $file, $1;
    }
  }

}
