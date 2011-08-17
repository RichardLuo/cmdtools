#!/usr/bin/perl -w
################################################################
# file: ParseAndroidManifest.pl
# author: Richard Luo
# date:   2011-08-17                                  
################################################################
use strict;
use warnings;

use strict;
use warnings;
use Getopt::Std;
use File::Basename;

while (<>) {
    if (s/package\s*=\s*"(\w+\.\w+.*)"/$1/) {
        print $1;
        exit 0;
    }
}
exit 100;


