#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(find diff);

# my $passwd = cat('</etc/passwd');
# print "\$passwd is [$passwd] \n";
# my @pslines = ps('-ef');
# print "pslines is:[\n";

# object oriented 
my $sh = Shell->new;

die "usage: \n\tmy_diff.pl [wildcard string for file filter] [source directories] [dest directories] \n" if $#ARGV != 2;

my $filter_string = shift;
my $source_dir = shift;
my $dest_dir = shift;
my $do_test = shift;

$source_dir =~ s[^\.\/*][];
$dest_dir =~ s[^\.\/*][];
die "source dir is the same as dest dir" if ($source_dir eq $dest_dir);

# print "\$filter_string is[$filter_string] \n";
# print "\$source_dir is[$source_dir] \n";
# print "\$dest_dir is[$dest_dir] \n";

my @src_files = $sh->find(" $source_dir -type f ".'-name ' . "\"$filter_string\"");
my $conv_regxp = $source_dir;
$conv_regxp =~ s[\/][\\\/]g;

my $has_any_overwrite = 0;
foreach(@src_files) {
	chomp;
	my $common_path = $_;
	$common_path =~ s/$conv_regxp//;					# delete the leading src path.
	my $dst_file = $dest_dir . '/' . $common_path;		# compose the dest path.
	$dst_file =~ s[\/\/][\/]g;							# this//dir -> this/dir
	chomp $dst_file;
	if (-f $dst_file) {
		my $params = "$_ $dst_file";
		my $has_dif = $sh->diff("-q $params");
		if ($has_dif) {									# only overwrite the file that has difference.
#			if (!$do_test) {
			if (0) {
#				print "cp -f $params \n";
#				$sh->cp("-f $params") eq "" or die "copy failed:$!\n";
			}else {
				print "$_\t$dst_file \n";
			}
			$has_any_overwrite = 1;						# at least has one file be overwrited.
		}
	} elsif (-e _) {
		print $sh->ls("-l $dst_file");
	}else {
		print "****************$dst_file does not exist!!**************** \n";
	}
}
print "There is No Differences \n" unless $has_any_overwrite;

