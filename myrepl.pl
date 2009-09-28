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



my @files = $sh->find(' -name *.[ch]');


