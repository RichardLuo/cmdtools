#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Shell qw(tar);

die "usage: $0 <file_suffix>" if ("" eq $ARGV[0]);
my $suffix = $ARGV[0];
print  "\$suffix is $suffix \n";
die "illegal input suffix " unless $suffix =~ /^(\d\.\d\d\.\d\d)/;


print "################ parsed version string is: [$suffix] ################ \n";
my $version = $1;

my $ver_info_file = "WAA2-VerInfo.txt";
open(OUTFILE, ">$ver_info_file") || die("Cannot open files\n");

print OUTFILE "VERSION='$version'". "\n";

my $image_file = "vmlinuz.english.$suffix.bin";
print OUTFILE "LOCATION='$image_file' \n";

(-e $image_file) || die("$image_file dose not exist!!! \n");

my $package_name = "waa2-release-".$suffix.".tar";

print "\$package_name is [$package_name] \n";

!tar("cf $package_name $image_file  $ver_info_file") || die("failed for tar");













