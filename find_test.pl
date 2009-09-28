#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use File::Find;

my @files;

# find(
#     sub {
#         push @files, $File::Find::name
#             if -f $File::Find::name && /\.c$/
#     },
#     "."
#     );


# find(
#     sub {
#         push @files, $File::Find::name
#             if -f $File::Find::name && /\.(c|cpp|h|hpp)$/
#     },
#     "."
#     );

# use File::Glob ':glob';
# @files = <*.[ch]>;

sub my_find_cb {
    push @files, $File::Find::name
        if -f $File::Find::name && /\.(c|cpp|h|hpp)$/
}


find { wanted=> \&my_find_cb, follow => 1, bydepth => 10 }, ".";


print join "\n", @files;






