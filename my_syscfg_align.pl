#!/usr/bin/perl -w
################################################################
# test_opt.pl
# Richard Luo
# 2008-07-08
################################################################
use strict;
use warnings;
use Getopt::Std;
use File::Basename;

sub usage () {
  print "usage:\n";
  print "\t-i input_file \n";
  print "\t-H output_header_file \n";
  print "\t-C output_cpp_file \n";
}

my %options=();
getopts("i:H:C:h",\%options);
# like the shell getopt, "d:" means d takes an argument

# print "-o $options{o}\n" if defined $options{o}; # 
# print "-d $options{d}\n" if defined $options{d};
# print "-f $options{f}\n" if defined $options{f};

if (defined $options{h}) {
  usage;
  exit(0);
}

if (!defined $options{i} || !defined $options{H} || !defined $options{C}) {
  usage;
  die "invlid input params \n";
}

my $input_file = $options{i};
my $output_hpp_file = $options{H};
my $output_cpp_file = $options{C};

print "input_file is $input_file \n";
print "output_hpp is $output_hpp_file \n";
print "output_cpp is $output_cpp_file \n";

open(IN_FILE, "< $input_file") or die "can not open $input_file: $!";
open(OUT_HPP_FILE, "> $output_hpp_file") or die "can not open $output_hpp_file: $!";
open(OUT_CPP_FILE, "> $output_cpp_file") or die "can not open $output_cpp_file: $!";


my @array_hpp;
my @array_cpp;

my $state = "cpp";             # 0: means write to cpp

# $source_dir =~ s[^\.\/*][];

my $head_macro = "__\U$output_hpp_file".'__';
$head_macro = basename($head_macro);
$head_macro =~ s/\./__/;

my $head_guard = '#ifndef'." $head_macro \n".'#define ' ."$head_macro 1 \n\n\n";


print OUT_HPP_FILE $head_guard;

my $basename_hpp = basename($output_hpp_file);
print OUT_CPP_FILE "#include \"$basename_hpp\" \n";

my $world_list;

while (<IN_FILE>) {

  s/private:/public:/;
  s/inline//;

  if (/^static .* wordlist/) {
      s/static\s*//;
      s/\[\]/\[MAX_HASH_VALUE+1\]/;
      $world_list = $_;
  }


  if (/enum/) {
    $state = "process_enum";
    print OUT_HPP_FILE;
    print "enum matched \n";
    next;
  }

  if ("process_enum" eq $state && /^\s*\};\s*$/) {
    print OUT_HPP_FILE "$_\n\n";
    $state = "cpp";
    next;
  }

  if (/^class\s+\w+/) {
    $state = "process_class";
    print OUT_HPP_FILE;
    next;
  }

  if ("process_class" eq $state && /^\s*\};\s*$/) {
    print OUT_HPP_FILE;
    $state = "cpp";
    next;
  }


  if ($state eq "cpp") {
    print OUT_CPP_FILE;
  }
  else {
    print OUT_HPP_FILE;
  }

}

# print "world_list is: $world_list \n";

$world_list =~ s/(.*)\s+=.*/extern $1;/;

print OUT_HPP_FILE "\n\n" . $world_list;
print OUT_HPP_FILE "\n\n#endif" . "\n";
