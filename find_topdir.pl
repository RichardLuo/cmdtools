#!/usr/bin/perl
my $curdir = `pwd`;
my $topdir = 'your_current_dir_is_not_legal_please_check_it';
chomp $curdir;

#print "current dir is [$curdir]" . "\n";
if ($curdir =~ /(^.*?CTC-IPCam\/(branches|trunk)\/\w+)/) {
  $topdir = $1;
}

print $topdir . "\n";
