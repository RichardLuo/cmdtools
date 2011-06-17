#!/usr/bin/perl -w
################################################################
# file: multi_unrar.pl
# author: Richard Luo
# date:   2010-09-19                                  
################################################################
use strict;
use warnings;


################
# for debug array.
################################################################
sub print_array {
	foreach(@_) {
		print $_, "\n";
	}
}

sub exec_commands {
  foreach (@_) {
    system($_) == 0 || die "system($_) failed!!";
  }

}

my (@file_list) = sort glob "*.rar";

# print "Returned list of file @file_list\n";

my $targetName = $file_list[0];
$targetName =~ s/(\d+).rar/$1/;
print $targetName . "\n";

shift @file_list;

my (@cmd_list);

my $iterName = $targetName;
foreach (@file_list) {
    $iterName += 1;
    my $cmd = "mv " . $_ . " " . $iterName . ".rar";
    push @cmd_list, $cmd;
}
push @cmd_list, "unrar x $targetName.rar";

print_array @cmd_list;

exec_commands @cmd_list;
