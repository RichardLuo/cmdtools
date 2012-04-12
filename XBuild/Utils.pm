package Utils;

use strict;
use File::Copy;

sub print_array;
sub has_main_entry;

################
# for debug array.
################################################################
sub print_array {
  foreach my $i (@_) {
    print $i, "\n";
  }
}

################
# to check whether the code has 'main' func definition.
# $1: local source file name
################################################################
sub has_main_entry {
  my ($file) = @_;
  my $result = 0;

  open(InFile, "< $file") or die "can not open local $file";
  while (<InFile>) {
    if (/^\s*(\bint\b|\bvoid\b|)\s*(main|ACE_TMAIN)\s*\(.*?\)/) {
      print "Note: $file have main func definition \n";
      $result = 1;
      last;
    }
  }
  close InFile;
  return $result;
}


# generate a local module name from the module path
sub get_base_local_module_name {
  my ($path) = @_;
  my $name_l = basename($path) if defined($path);
  my $name_h = basename(dirname($path)) if defined($path);
  if ($name_h eq "/") { # the case like '/test', just under the root dir
    return $name_l;
  } else {
    return $name_h . "_" . $name_l;
  }
}


################
# exec_commands(@command_array);
################################################################
sub exec_commands {
  foreach my $i (@_) {
    system($i) == 0 || die "system($i) failed!!";
  }
}

sub do_nothing_exit {
  print "nothing to do, exit 0\n";
  exit(0);
}

sub backup_file {
  my ($file) = @_;
  if (defined($file) && -f "$file") {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
      localtime();
    my $backup_name = sprintf("old.%s.%02d%02d%02d%02d%02d", $file, $mon+1, $mday, $hour, $min, $sec);
    copy("$file","$backup_name") or die "Copy failed: $!";
    print "[Backup]: $file --> $backup_name \n";
  }
}



1;
