#!/usr/bin/perl -w
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

if ($parser->parse($ENV{PWD}) == 1) {
  $parser->execute_gen_xbuild_makefile;
}

