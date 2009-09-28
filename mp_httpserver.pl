#!/usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;

my $d = HTTP::Daemon->new(
#    LocalAddr => "172.18.83.119:45678",
    ReuseAddr => 1,
    ) || die;

print "Please contact me at: <URL:", $d->url, ">\n";

my $proto = '1.1';

while (my $c = $d->accept) {
    print "accept returned \n";

    while (my $r = $c->get_request) {

    print "invalid request: method: [$r->method] url: [$r->url] \n";

    die "the client unsupport http1.1" unless ($c->proto_ge( $proto ));

        if ($r->method eq 'GET' and $r->url->path eq "/xyzzy") {
            # remember, this is *not* recommended practice :-)
            $c->send_file_response("/etc/passwd");
        }
        else {
#            print "invalid request: $r->method \n";
            $c->send_error(RC_FORBIDDEN)
        }
    }
    $c->close;
    undef($c);
}
