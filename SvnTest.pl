#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(cat ls find diff mkdir svn);

my $sh = Shell->new;

################
# for debug array.
################################################################
sub print_array {
	foreach(@_) {
        chomp;
		print $_, "\n";
	}
}

################
# to check whether the code has 'main' func definition.
################################################################
sub file_has_main_func_definition {
  my $file = shift;
  chomp $file;
  my $contents = join('', $sh->cat("$file")); # there should be a better way to do this.
#  print $contents;
  if ($contents =~ /\n\s*(int|void)\s+main\s*\(.*?\)/m) { # refex multiline match
      print "Note: $file have main func definition \n";
      return 1;
  }
  return 0;
}

################
# generate_commands($src_file, $dst_file);
# return: command string.
################################################################
sub generate_commands {
  my $srcfile = shift;
  my $dstdir = shift;
  my $cmd_prefix = sprintf("mv %18s%18s", $srcfile, $dstdir);
  return $cmd_prefix;
}

################
# to check whether local svn file is up to date.
# died if not!
################################################################
sub assert_svn_uptodate {
  my @svn_status = $sh->svn("st ");
  if (@svn_status) {
    print_array @svn_status;
    die "snv is not up to date please do check!";
  }
}

################
# exec_commands(@command_array);
################################################################
sub exec_commands {
  foreach (@_) {
    system($_) == 0 || die "system($_) failed!!";
  }
}

# die "usage: \n\t [wildcard string for file filter] \n" if $#ARGV != 2;

my $filter_string = shift;
my $source_dir = shift;

# my @srcfiles = $sh->find(" $source_dir ".'-name ' . " \"$filter_string\"");

my @svninfo = $sh->svn(" info \"$filter_string\" ");

print_array @svninfo;


# assert_svn_uptodate;

# $sh->mkdir("-p $src_dir $inc_dir $lib_dir");
# #$sh->svn("add  $src_dir $inc_dir $lib_dir") || die "lyk svn add error!!!";

# exec_svninfo @svninfo;

