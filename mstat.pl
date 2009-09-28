#!/usr/bin/perl -w

use strict;
use warnings;
use diagnostics;



#use Unix::Mknod qw(:all);
use File::stat;
use Fcntl qw(:mode);

# $st=stat('/dev/null');
# $major=major($st->rdev);
# $minor=minor($st->rdev);

# mknod('/tmp/special', S_IFCHR|0600, makedev($major,$minor+1));


my @dev_files = glob "*";
foreach (@dev_files) {
    my $st = stat $_;

#     my $major = major($st->rdev);
#     my $minor = minor($st->rdev);

#    print "$_.major=[$major] $_.minor=[$minor] \n";
    print "$_:@$st \n";
    print "dev: $st->dev \n";
}

