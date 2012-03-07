#!/usr/bin/perl -w
# use strict;
use warnings;
use diagnostics;
use Shell qw(ls find diff);

use File::Basename;

# ($name,$path,$suffix) = fileparse($fullname,@suffixlist);
# $name = fileparse($fullname,@suffixlist);
# $basename = basename($fullname,@suffixlist);
# $dirname = dirname($fullname);

# my $passwd = cat('</etc/passwd');
# print "\$passwd is [$passwd] \n";
# my @pslines = ps('-ef');
# print "pslines is:[\n";
#

# object oriented 
my $sh = Shell->new;
#print $sh->ls('-l');

# print "\$#ARGV is $#ARGV \n";

die "\n\nusage: \n\tmy_diff.pl <\"filter params\"> <left path> <right path> \n\n" .
    "example: \n\n\tmydiff.pl \"-type f -name *.[ch]\" ./package1/ ./package2/ \n\n"
    if $#ARGV != 2;

my $filter_string = shift;
my $source_dir = shift;
my $dest_dir = shift;

$source_dir = dirname($source_dir) . "\/" . basename($source_dir);
$dest_dir = dirname($dest_dir) . "\/" . basename($dest_dir);

# print "\$filter_string is[$filter_string] \n";
# print "\$source_dir is[$source_dir] \n";
# print "\$dest_dir is[$dest_dir] \n";

## my @src_files = find(" $source_dir " . '-name ' . " \"$filter_string\"");
my @src_files = find(" $source_dir " . " $filter_string");
my @dst_files = find(" $dest_dir " . " $filter_string");
# my @src_files = find(' ./osd.78/ -name *.[ch] ' );


my @diff_results = ();
my @file_existing_results = ();

sub delete_entry 
{
    my $array_ref = shift;
    my $dst_dir = shift;
    my $pattern = shift;

    my $conv_regxp = $dst_dir;
    $conv_regxp =~ s[\/][\\\/]g;

    my $i = 0;
    foreach (@$array_ref) {
        if (/$pattern/) {
            chomp;
            my $common_path = $_;
            $common_path =~ s/$conv_regxp//;
            # print "================ common_path:{$common_path} == ". "pattern {$pattern} \n";
            # print "delete $$array_ref[$i] \n";
            splice @$array_ref, $i, 1;
            last;
        }
        ++$i;
    }
}

sub compare_files
{
    my $s_files = shift;
    my $d_files = shift;
    my $s_dir = shift;
    my $d_dir = shift;

    my $conv_regxp = $s_dir;
    $conv_regxp =~ s[\/][\\\/]g;

    foreach (@$s_files) {
        if ($_) {
            chomp;
            my $common_path = $_;
            $common_path =~ s/$conv_regxp//;

            my $dst_file = $d_dir.$common_path;
#            print "dst_file:$dst_file \n";
            chomp $dst_file;
            die  "err!!!!" unless ( -e $_ );

            if (-e $dst_file) {
                my $params = "$_ $dst_file";
                # my $diff_res = $sh->diff("-w -B -N -C 4 $_ $dst_file");
##                print "diff -q $_ $dst_file \n";
                my $diff_res = $sh->diff("-q $_ $dst_file");
                if ($diff_res) {
                    push(@diff_results, $diff_res);
                }
            } else {
                push(@file_existing_results, "$dst_file does not exist! \n");
            }
#            print "common_path:{$common_path} \n";
            delete_entry(\@$d_files, $d_dir, $common_path);
        }
    }

}

compare_files(\@src_files, \@dst_files, $source_dir, $dest_dir);
compare_files(\@dst_files, \@src_files, $dest_dir, $source_dir);

foreach(@diff_results, @file_existing_results) {
	print;
}

# print "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh \n";
# foreach(@dst_files) {
#     chomp;
#     print $_ . "\n";
# }
