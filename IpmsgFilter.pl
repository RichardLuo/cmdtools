#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(ls find diff);

my $sh = Shell->new;


# print "\n**************************************************************** \n";
# print @ARGV;
# print "\n**************************************************************** \n";

my $input_file = $ARGV[0];
open(IN_FILE, "< $input_file") or die "can not open $input_file: $!";

my $line = 0;



my $is_start = 0;

for(;<IN_FILE>; ++$line ) {
    chop;
    if ($is_start == 0) {
        if ( /(To|From):.*Hello/i ) {
            $is_start = 1;
        }
        if ( /(To|From):.*richard/i ) {
            $is_start = 1;
        }
        if ( /(To|From):.*e333355/i ) {
            $is_start = 1;
        }
    }

    next if $is_start == 0;
    if (/=====================================/) {
        $is_start = 0;
        print "=====================================\n";
    }
    if ( $is_start == 1 ) {
        print "$_" . "\n";
    }
}
