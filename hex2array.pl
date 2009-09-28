#!/usr/bin/perl -w
sub printArray {
	print "SSSSSSSSSSSSSSSS \n";
	foreach(@_) {
		print;
		print "\n";
	}
	print "EEEEEEEEEEEEEEEE \n\n";
};

sub my_unpack { 
	local ($_) = @_;
	$_ = unpack ("B*", pack ("H*", $_));
	$width=length($_);
	s/(.{$width})/$1/g;
	y/01/-#/;
	$_;
};

sub my_pack { 
	local ($_) = @_; 
	y/-#/01/;
	$_= unpack ("H*", pack ("B*", $_));
	y/a-f/A-F/;
	$_;
}


#################################################################
#						Main Function							#
#################################################################

# print "\$ARGV[-2]=$ARGV[-2], \$ARGV[-1]=$ARGV[-1], \$ARGV[0]=$ARGV[0], \$ARGV[1]=$ARGV[1], \$ARGV[2]=$ARGV[2] \n";
# print "**************************************************************** \n";

print "\n**************************************************************** \n";
print @ARGV;
print "\n**************************************************************** \n";
my $FontFile = $ARGV[0];
my $ArrayFile = $FontFile.'.c';

open(COFile, "> $ArrayFile") or die "can not open $ArrayFile: $!";
open(INFile, "< $FontFile") or die "can not open $FontFile: $!";
open(LOGFILE, "> FontLog") or die "can not open plLog: $!";

my $ArrayName = $FontFile;
$ArrayName =~ s/.*?(\w+$)/$1/;
my $FirstLine = 'static unsigned char '.$ArrayName.'[]= {'."\n";
print COFile $FirstLine;

my $oneSize = 1;
my $oldV = 0;
my $line = 0;
my $step;
for(;<INFile>; ++$line ) {
	next unless /....:/;
	s/\s//;
	my @value = split(':', $_);
	$value[0] = "0x".$value[0];
	my @eleCont = split(//,$value[1]);

# 	print "****************\$#eleCont=$#eleCont \n";

	my @charArray = ();
	my $i=0;
	my $comment=();
	$step = $#eleCont == 31 ? 2 : $#eleCont == 63 ? 4 : 0;
	if ($step == 0) {
		print "==== error \n";
		exit(-1);
	}
	for(; $i <= $#eleCont; $i += $step) {
		$comment = $step == 4 ? $eleCont[$i].$eleCont[$i+1].$eleCont[$i+2].$eleCont[$i+3] : $eleCont[$i].$eleCont[$i+1];
		$comment =~ s/([0-9A-F]{$step})/&my_unpack($1)/ie;

# 		print "\$comment=[$comment] \n";

		if ($step == 4) {
			$charArray[$i/$step] = "\t0x".$eleCont[$i].$eleCont[$i+1].", 0x".$eleCont[$i+2].$eleCont[$i+3].",\t\t \/\*$comment\*\/ \n";
		}
		else {
			$charArray[$i/$step] = "\t0x".$eleCont[$i].$eleCont[$i+1].",\t\t \/\*$comment\*\/ \n";
		}
	}

	if ($oldV != 0 && $oldV != $step) {	# after the 1st line, if convertion happened...
		my $hint = $oldV == 2 ? "==== 2 ==> 4 ==== \n" : "==== 4 ==> 2 ==== \n";
		my $max = $line - 1;
		print LOGFILE "---$max]\n", $hint, "[".$line;
		$oneSize = 0;			# at least 2 font size;
		
	}elsif ($oldV == 0) {		# the first line.
		my $hint = "++++ start from $step ++++";
		print LOGFILE $hint, "\n[", $line;
	}
	$oldV = $step;

	my $head = $value[0];

# 	print "\$head=$head \n";

	$head = "\t\/\* \t$head\t \*\/ \n";
	my $tail = "\n\n";
	print COFile $head, @charArray, $tail;
#	printArray(@charArray);
}
print COFile '};', "\n\n";

my $preFix = $ArrayName;
$preFix =~ s/\w+_(.*)/$1/;

# last structure block
my $sizeStr = $oldV==4 ? "16x16" : "8x16";
my $strucName = 'font_unicode_'.$sizeStr;
$strucName = 'struct lcd_font_desc '.$strucName.' = {'."\n";
print COFile $strucName;
# struct content
# idx
my $idxName = 'VGA_UNICODE_'.$preFix.'_IDX,'."\n";
print COFile "\t" . $idxName;
# name
my $nameName = '"PCFont_'.$preFix.$sizeStr.'"'.",\n";
print COFile "\t" . $nameName;
# width
my $widthName = $sizeStr;
$widthName =~ s/([0-9]+)x([0-9]+)/$1/;
print COFile "\t" . $widthName.",\n";
print "\$widthName=$widthName \n";

# height
print "\$sizeStr=$sizeStr \n";
my $heightName = $sizeStr;
$heightName =~ s/([0-9]+)x([0-9]+)/$2/;
print COFile "\t" . $heightName.",\n";
print "\$heightName=$heightName \n";

# data
my $dataName = $ArrayName;
print COFile "\t" . $dataName.",\n";
# pref
my $prefName = '-2000';
print COFile "\t" . $prefName."\n".'}'.";";


close COFile;
close INFile;
close LOGFILE;

exit(0);




