#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
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
  if ($contents =~ /\n\s*(int|void)\s+(main|ACE_TMAIN)\s*\(.*?\)/m) { # refex multiline match
      print "Note: $file have main func definition \n";
      return 1;
  }
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

my @src_files = glob "*.c *.cpp";
my @head_files = glob "*.h *.hpp";

if (!@src_files && !@head_files) {
    die "no source files here!!";
}

#print_array @src_files;

my @commands;
my $need_src_dir=0;

foreach (@src_files, @head_files) {
  my $dst_dir = m[\.cp{0,2}$] ? "$src_dir" : "$inc_dir";
  my $cmd = generate_commands($_, $dst_dir);
  if (!file_has_main_func_definition($_)) {
      push @commands, $cmd;
      $need_src_dir = 1;
  }
}

my $examp_mk = 'makefiles/example.mk';

if (-f "Makefile") {
    my $prefix = $sh->date(" +%Y%m%d_%S");
    chop $prefix;
    push @commands, "mv Makefile org.$prefix.mk";
}

splice @commands, 0, 0, "mkdir -p $inc_dir" unless @head_files <= 0;
splice @commands, 0, 0, "mkdir -p $src_dir" unless $need_src_dir == 0;

push @commands, "cp $ENV{DOOB_ROOT}/$examp_mk ./Makefile";

print "================ I will do executing the following commands ================" . "\n";
print_array @commands;
print "============================================================================" . "\n";


#assert_svn_uptodate;

# $sh->mkdir("-p $src_dir") unless @src_files <= 0;
# $sh->mkdir("-p $inc_dir") unless @head_files <= 0;

#$sh->svn("add  $src_dir $inc_dir $lib_dir") || die "lyk svn add error!!!";

exec_commands @commands;

print
    "################################################################" . "\n",
    "building sys conversion ok, please modify the generated example"  . "\n",
    "makefile to meet your needs, you can refer to apps/vsp/Makefile"  . "\n",
    "################################################################" . "\n";
