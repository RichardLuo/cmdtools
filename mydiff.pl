#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(ls find diff);


# my $passwd = cat('</etc/passwd');
# print "\$passwd is [$passwd] \n";
# my @pslines = ps('-ef');
# print "pslines is:[\n";



# object oriented 

my $sh = Shell->new;
#print $sh->ls('-l');

# print "\$#ARGV is $#ARGV \n";

die "usage: \n\tmy_diff.pl [wildcard string for file filter] [source directories] [dest directories] \n" if $#ARGV != 2;

my $filter_string = shift;
my $source_dir = shift;
my $dest_dir = shift;

# print "\$filter_string is[$filter_string] \n";
# print "\$source_dir is[$source_dir] \n";
# print "\$dest_dir is[$dest_dir] \n";

my @src_files = find(" $source_dir ".'-name ' . " \"$filter_string\"");
# my @src_files = find(' ./osd.78/ -name *.[ch] ' );

my $conv_regxp = $source_dir;
$conv_regxp =~ s[\/][\\\/]g;

my @diff_results = ();

#print "\$conv_regxp is[$conv_regxp] \n";

foreach(@src_files) {
	chomp;
	my $common_path = $_;
	$common_path =~ s/$conv_regxp//;
	my $dst_file = $dest_dir.$common_path;
	chomp $dst_file;
#	print "\$dst_file is [$dst_file] \n";
	if (-e $dst_file) {
		my $params = "$_ $dst_file";
		my $diff_res = $sh->diff("-w -B -N -C 4 $_ $dst_file");
		if ($diff_res) {
			push(@diff_results, $diff_res);
		}
	} else {
		print "****************$dst_file does not exist!!**************** \n";
	}
}

foreach(@diff_results) {
	print;
}
