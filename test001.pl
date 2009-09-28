#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Shell qw(cat ps cp find);

my $passwd = cat('</etc/passwd');
print "\$passwd is [$passwd] \n";
#my @pslines = ps('-ww'), cp("/etc/passwd", "/tmp/passwd");
my @pslines = ps('-ef');
print "pslines is:[\n";

foreach(@pslines) {
	print "\t" . $_ 
}
print "]\n";

# object oriented 
my $sh = Shell->new;
print $sh->ls('-l');





# die "usage: \n\tmy_diff.pl [command] [source directories] [dest directories] \n" if $#ARGV != 2;

# my $command = shift;
# my $source_dir = shift;
# my $dest_dir = shift;
# my @src_files = 
# print "my command is[$command].\n";

# foreach(@ARGV){
# 	my $dest_dir
#  	if ($source_dir =~ m[^\.\/]) {	# ./osd/...
# 		$source_dir =~ s/^\.\/(.*?\/)//;
# 	}elsif ($source_dir =~ m[^\w+]) { # osd/...
# 		$source_dir =~ s[^.*?\/][];
# 	}else {
# 		die "stange $source_dir \n";
# 	}

# 	$source_dir =~ s/CVS$//;
# 	$source_dir = $dstPrefix.'/'.$source_dir;
# 	next unless -d $source_dir;

# 	if (-d $source_dir) {
# 	}else{
# 		print "==== $source_dir does not exist! \n";
# 		next;
# 	}


# 	my $cmd = "cp -R $_ $source_dir";
# 	if (system($cmd)) {
# 		print "failed to \t[$cmd]\n";
# 	}else{
# 		print "ok to \t[$cmd]\n";
# 	}
# }

