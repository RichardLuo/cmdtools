#!/usr/bin/perl


#
# Globals
#
use vars qw/ %opt /;

#
# Command line options processing
#
sub init()
{
    use Getopt::Std;
    my $opt_string = 'hvdf:';
    getopts( "$opt_string", \%opt ) or usage();
    usage() if $opt{h};
}

#
# Message about this program and how to use it
#
sub usage()
{
    print STDERR << "EOF";

    This program does...

      usage: $0 [-hvd] [-f file]

      -h        : this (help) message
      -v        : verbose output
      -d        : print debugging messages to stderr
      -f file   : file containing usersnames, one per line

    example: $0 -v -d -f file

    EOF
    exit;
}

init();

print STDERR "Verbose mode ON.\n" if $opt{v};
print STDERR "Debugging mode ON.\n" if $opt{d};
