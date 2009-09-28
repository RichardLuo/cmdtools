#!/usr/bin/perl

use Net::HTTP;

my $host = '59.60.28.226';

my $s = Net::HTTP->new(Host => "$host") || die $@;
$s->write_request(GET => "/", 'User-Agent' => "Mozilla/5.0");
my($code, $mess, %h) = $s->read_response_headers;

while (1) {
    my $buf;
    my $n = $s->read_entity_body($buf, 1024);
    die "read failed: $!" unless defined $n;
    last unless $n;
    print $buf;
}
