#!/usr/bin/perl -w
################################################################
# tftp_put.pl
# Richard Luo
# 2008-10-10
################################################################

# use strict;
# use warnings;

use TFTP;

my $tftp = new TFTP("127.0.0.1");
$tftp->get("jff2.128");
$tftp->octet;
$tftp->put("tftp_put.pl");
$tftp->quit;
