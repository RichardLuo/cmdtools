#!/usr/bin/perl
print "\$#argv is $#ARGV \n";
die "usage: \n\tcp_cvsdir.pl [dest directory path prefix] [src dir lists] \n\tthere should be at least too arguments, one for dest path's prefix, one for source directory.\n" if $#ARGV < 1;

$dstPrefix = shift @ARGV;
print $dstPrefix."\n";

foreach(@ARGV){
	$dest = $_;
	if ($dest =~ m[^\.\/]) {	# ./osd/...
		$dest =~ s/^\.\/(.*?\/)//;
	}elsif ($dest =~ m[^\w+]) { # osd/...
		$dest =~ s[^.*?\/][];
	}else {
		die "stange $dest \n";
	}

	$dest =~ s/CVS$//;
	$dest = $dstPrefix.'/'.$dest;
#	next unless -d $dest;

	if (-d $dest) {
	}else{
		print "==== $dest does not exist! \n";
		next;
	}


	$cmd = "cp -R $_ $dest";
	if (system($cmd)) {
		print "failed to \t[$cmd]\n";
	}else{
		print "ok to \t[$cmd]\n";
	}
}

