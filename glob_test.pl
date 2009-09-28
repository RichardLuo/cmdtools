#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(cat ls find diff mkdir svn);

my $sh = Shell->new;

sub print_array {
	foreach(@_) {
		print $_, "\n";
	}
};


sub file_has_main_func_definition {
  my $file = shift;
  chomp $file;
  my $contents = join('', $sh->cat("$file"));
#  print $contents;
  if ($contents =~ /\n\s*\w+\s*\bmain\b\s*\(.*?\)/m) {
      print "==== Note: $file have main func definition \n";
      return 1;
  }
  return 0;
}

sub gen_cmd {
  my $srcfile = shift;
  my $dstdir = shift;
  my $cmd_prefix = sprintf("svn mv %18s%18s", $srcfile, $dstdir);
  return $cmd_prefix;
}


sub assert_svn_uptodate {
  my @svn_status = $sh->svn("st ");
  if (@svn_status) {
    print_array @svn_status;
    die "snv is not up to date please do check!";
  }
}

sub exec_commands {
  foreach (@_) {
    system($_) == 0 || die "system($_) failed!!";
  }
}

#die "usage: \n\tmy_diff.pl [wildcard string for file filter] [source directories] [dest directories] \n" if $#ARGV != 2;

my $src_dir = "src";
my $inc_dir = "include";
my $lib_dir = "lib";

#my @src_files = $sh->find(" $src_dir ".'-name ' . "\"$filter_string\"");
my @src_files = glob "*.c";
my @head_files = glob "*.h";

if (!@src_files && !@head_files) {
    die "no source files here!!";
}

#print_array @src_files;

my @commands;

foreach (@src_files, @head_files) {
  my $dst_dir = m[\.c$] ? "$src_dir" : "$inc_dir";
  my $cmd = gen_cmd($_, $dst_dir);
  if (!file_has_main_func_definition($_)) {
#    print "\$cmd to push: [$cmd] \n";
    push(@commands, $cmd);
  }
}

print_array @commands;

# $sh->mkdir("-p $src_dir $inc_dir $lib_dir");
# $sh->svn("add  $src_dir $inc_dir $lib_dir") || die "lyk svn add error!!!";


print "################ building sys conversion ok!!! ################ \n";
