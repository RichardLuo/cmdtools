#!/usr/bin/perl -w

use File::stat;
use File::Stat::Bits;

my @files = glob "./*";



my $path_prefix = './';

#mknod /dev/${device}0 c $major 0


foreach (@files) {
    my $st = stat($_) or die "Can't stat $_: $!";
    if ( S_ISCHR($st->mode) ) {
        my ($major, $minor) = dev_split( $st->rdev );
        print "mknod $_ c $major $minor \n";
    }

    if ( S_ISBLK($st->mode) ) {
        my ($major, $minor) = dev_split( $st->rdev );
        print "mknod $_ b $major $minor \n";
    }
}
