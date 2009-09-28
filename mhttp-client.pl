#!/usr/bin/perl

use HTTP::Lite;
$http = new HTTP::Lite;
$req = $http->request("http://www.baidu.com/") or die "Unable to get document: $!";
print $http->body();
