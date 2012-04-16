#!/usr/bin/perl -w
################################################################
# file:   test_XBuildModuleParser.pl
# author: Richard Luo
# date:   2012-04-12 12:42:14
################################################################
use strict;
use warnings;
use XBuild::XBuildModuleParser;
use XBuild::XBuildModuleInfo;
use File::Basename;

#create Employee class instance
my $module_info = new XBuildModuleInfo() or die ($@);
my $parser = new XBuildModuleParser() or die ($@);
$parser->set_module_info($module_info);

#set object attributes
# $parser->set_local_module('module_name_hello');
my @sources = glob "*.c *.cpp *.cxx *.cc";
my @headers = glob "*.h";

$parser->set_source_files(\@sources);
$parser->set_header_files(\@headers);
$parser->set_directories('src', 'include');
my $gen = $parser->parse($ENV{PWD});
my $lmk_file = "$ENV{PWD}/Makefile";
if ($gen == 1) {
  Utils::backup_file("$ENV{PWD}/Makefile");
  $module_info->gen_xbuild_makefile($lmk_file);
}
else {
  print "Doesn't need to genereate the $lmk_file \n";
}




