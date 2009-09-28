#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;

use Shell qw(cat);

sub get_simbol {
	$_ = shift;
	if (/^(\w+)/) {
		return $1;
	}
}
my $sh = Shell->new;
#die "usage: myparsesymbol.pl your_file_path" if $#ARGV != 0;
my @lines = <>;

my $i=0;
my @conflict_symbols = ();
my %allconficts = ();

for (; $i < @lines-1; ) {
	my $symbol_old = get_simbol($lines[$i]); 
	my $symbol_new = "";
	next unless $symbol_old;

	push @conflict_symbols, $lines[$i];
	my $ii = $i+1;

	for ($symbol_new = get_simbol($lines[$ii]); $symbol_new eq $symbol_old; $symbol_new = get_simbol($lines[$ii]), ++$ii){
		push @conflict_symbols, $lines[$ii];
	}

	if ($ii > $i+1) {
		$allconficts{$symbol_old} = @conflict_symbols; # insert.
		$i = $ii;
	}else {
		@conflict_symbols = ();	# clear.
		++$i;
	}
}







