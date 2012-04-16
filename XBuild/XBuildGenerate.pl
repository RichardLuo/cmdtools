#!/usr/bin/perl -w
use strict;
use warnings;
use XBuild::XBuildModuleParser;
use XBuild::XBuildModuleInfo;
use File::Basename;

my $module_info = new XBuildModuleInfo() or die ($@);
my $module_parser = new XBuildModuleParser() or die ($@);
$module_parser->set_module_info($module_info);

my @c_sources = glob "*.c";
my @cpp_sources = glob "*.cpp *.cxx *.cc";
my @headers = glob "*.h *.hpp";

if (@c_sources > 0 && @cpp_sources > 0) {
  die "can not contain both C and CPP source files \n";
}

if (@c_sources > 0) {
  $module_info->set_codetype('c');
  $module_parser->set_source_files(\@c_sources);
} else {
  $module_info->set_codetype('cpp');
  $module_parser->set_source_files(\@cpp_sources);
}

$module_parser->set_header_files(\@headers);
$module_parser->set_directories('src', 'include');

if ($module_parser->parse($ENV{PWD}) == 1) {
  $module_parser->execute_gen_xbuild_makefile;
}

