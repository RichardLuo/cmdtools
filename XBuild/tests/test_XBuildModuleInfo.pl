#!/usr/bin/perl -w
################################################################
# file:   test_XBuildModuleInfo.pl
# author: Richard Luo
# date:   2012-04-16 13:30:04
################################################################
use strict;
use warnings;
use XBuild::XBuildModuleInfo;

my $module_info = new XBuildModuleInfo() or die ($@);

$module_info->parse_makefile("./Makefile");
$module_info->self_dump();
$module_info->gen_xbuild_makefile("XB.mk");

