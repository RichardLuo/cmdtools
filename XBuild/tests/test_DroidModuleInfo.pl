#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use XBuild::DroidModuleInfo;

#create Employee class instance
my $droid_mod =  eval { new DroidModuleInfo(); }  or die ($@);

#set object attributes
$droid_mod->set_local_module('module_name_hello');
$droid_mod->append_local_src_file('hell1.cpp');
$droid_mod->append_local_src_file('hell2.cpp');
$droid_mod->append_local_src_file('hell3.cpp');
$droid_mod->set_build_type('BUILD_SHARED_LIBRARY');

$droid_mod->append_code_body("code line 1\n");
$droid_mod->append_code_body("code line 2\n");
$droid_mod->append_code_body("code line 3\n");
$droid_mod->append_code_body("code line 4\n");

#diplay Employee info
$droid_mod->print();

$droid_mod->gen_android_makefile();

