#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use File::Find;
use File::Find::Rule;


my @files = File::Find::Rule->file()->name('*.pm' )->in( @INC );
print join "\n", @files;
