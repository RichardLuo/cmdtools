#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use File::Basename;

use Shell qw(cat ls find diff mkdir svn date);



my $sh = Shell->new;

################
# for debug array.
################################################################
sub print_array {
	foreach(@_) {
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
  if ($contents =~ /\n^\s*(\bint\b|\bvoid\b|)\s*(main|ACE_TMAIN)\s*\(.*?\)/m) {
      print "Note: $file have main func definition \n";
      return 1;
  }

  # if ($contents =~ /\n^\s*(\bint\b|\bvoid\b|)\s*(main|ACE_TMAIN)\s*\(.*?\)/m ||
  #     $contents =~ /\n^\s*(main|ACE_TMAIN)\s*\(.*?\)/m) { # refex multiline match
  #     print "Note: $file have main func definition \n";
  #     return 1;
  # }

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

my $src_dir = "src";
my $inc_dir = "include";

my @src_files = glob "*.c *.cpp *.cxx *.cc";
my @head_files = glob "*.h *.hpp";

if (!@src_files && !@head_files) {
    die "no source files here!!";
}

#print_array @src_files;

my @commands;

my @main_entry_files;                   # list of source files that contains the 'main()' entry function
my @common_src_files;                   # list of source files that should be moved to ./src

foreach (@src_files, @head_files) {
  my $dst_dir = m[\.cp{0,2}$] ? "$src_dir" : "$inc_dir";
  my $cmd = generate_commands($_, $dst_dir);
  if (!file_has_main_func_definition($_)) {
      push @commands, $cmd;
      push @common_src_files, $_;
  }
  else {
      push @main_entry_files, $_;
  }
}

my $examp_mk = 'example.mk';

if (-f "Makefile") {
    my $prefix = $sh->date(" +%Y%m%d_%S");
    chop $prefix;
    push @commands, "mv Makefile org.$prefix.mk";
}

splice @commands, 0, 0, "mkdir -p $inc_dir" unless @head_files <= 0;
splice @commands, 0, 0, "mkdir -p $src_dir" unless @common_src_files <= 0;

## push @commands, "cp $ENV{HOMESYS_ROOT}/kkbuild/$examp_mk ./Makefile";

print "\n";
print "================ I will do executing the following commands ================" . "\n";
print_array @commands;
print "============================================================================" . "\n";
print "\n";


#assert_svn_uptodate;

$sh->mkdir("-p $src_dir") unless @src_files <= 0;
$sh->mkdir("-p $inc_dir") unless @head_files <= 0;

# $sh->svn("add  $src_dir $inc_dir $lib_dir") || die "lyk svn add error!!!";

exec_commands @commands;
print
    "################################################################" . "\n",
    "building sys conversion ok, please modify the generated example"  . "\n",
    "makefile to meet your needs, you can refer to apps/vsp/Makefile"  . "\n",
    "################################################################" . "\n";
print "\n";

################################################################
# parse @main_entry_files to get the 'EXENAME'
################
my $exe_name_prefix = "EXENAME =";
my $exe_name_str = $exe_name_prefix;
if (@main_entry_files > 0) {
    foreach (@main_entry_files) {
#        print "== $_ \n";
        my $basename = basename $_;
        (my $exe_file = $basename) =~ s/\.[^.]+$//;
        if ($exe_file =~ /^test/ ||
            $exe_file =~ /^t_/ ) {
#            print "$exe_file is a unit test file \n";
            next;
        }
        $exe_name_str .= " $exe_file";
        print "$exe_name_str\n";
    }
}

################################################################
# start to parsing the CODE_TYPE
################
my $code_type = "CODE_TYPE := ";
my $code_type_var = "";
foreach (@src_files) {
    if ($_ =~ /\w+\.c$/) {
        if ($code_type_var eq "") {
            $code_type_var = "c";
        } elsif ($code_type_var eq "cpp") {
            print "$_ is a C source file, but there exists CPP source file \n";
            die "C and CPP can not co-exist within one module!";
        } elsif  ($code_type_var eq "c") {
#            print "C continue: $_ \n";
        } else {
            die "illegal code_type_var:$code_type_var";
        }
    }
    elsif ($_ =~ /^\w+\.cpp$/ ||
        $_ =~ /^\w+\.cxx$/ ||
        $_ =~ /^\w+\.cc$/ ) {
        if ($code_type_var eq "") {
            $code_type_var = "cpp";
        } elsif ($code_type_var eq "c") {
            print "$_ is a CPP source file, but there exists C source file \n";
            die "C and CPP can not co-exist within one module!";
        } elsif  ($code_type_var eq "cpp") {
#            print "cpp continue: $_ \n";
        } else {
            die "illegal code_type_var:$code_type_var";
        }
    }
    else {
        die "illegal source file:$_";
    }
}
$code_type = $code_type . $code_type_var;

my $example_makefile = "$ENV{HOMESYS_ROOT}/kkbuild/example.mk";
my @makefile_lines;

open(INFile, "< $example_makefile") or die "can not open $example_makefile";

################################################################
# start to parsing the LIBNAME
################
my $lib_module_name = "LIBNAME := ";
if ($exe_name_str eq $exe_name_prefix) {
    my $name_l = basename $ENV{PWD};
    my $name_h = basename(dirname $ENV{PWD});
    if ($name_h eq "/") {               # the case like '/test', just under the root dir
        $lib_module_name .= "lib" . $name_l . ".a";
    } 
    else {
#        print "name_l:$name_l, name_h:$name_h \n\n" ;
        $lib_module_name .= "lib" . $name_h . "_" . $name_l . ".a";
    }
    print "$lib_module_name \n";
    push @makefile_lines, $lib_module_name;
} 
else {
    push @makefile_lines, $exe_name_str
}

push @makefile_lines, $code_type;

for( ; <INFile>; ) {
    chomp;
    push @makefile_lines, $_;
}
close INFile;

open(OUTFILE, ">Makefile") || die("Cannot open Makefile files\n");
foreach (@makefile_lines) {
    print OUTFILE "$_\n";
}
close OUTFILE;

print "$code_type\n";

