#!/usr/bin/perl -w
################################################################
# file:   test_XBuildModuleParser.pl
# author: Richard Luo
# date:   2012-04-12 12:42:14
################################################################
use strict;
use warnings;
use XBuild::XBuildModuleParser;

#create Employee class instance
my $parser =  eval { new XBuildModuleParser(); }  or die ($@);
print "================================================================\n";
#set object attributes
# $parser->set_local_module('module_name_hello');
my @sources = glob "*.c *.cpp *.cxx *.cc";
my @headers = glob "*.h";

$parser->set_source_files(\@sources);
$parser->set_header_files(\@headers);
$parser->set_directories('src', 'include');


$parser->parse("/hello/kkbuild/nihao");

$parser->dprint();




