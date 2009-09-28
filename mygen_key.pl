#!/usr/bin/perl -w

my $SysConfigFile = $ARGV[0];

open(INFile, "< $SysConfigFile") or die "can not open $SysConfigFile";

for(;<INFile>;) {
	next unless /(^\w+)=/;
print $1 . "\n";

}

