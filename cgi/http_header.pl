#!perl -w

use strict;
use warnings;
use LWP;



my $ua = new LWP::UserAgent;
$ua->agent("DummyUserAgentPerlScript/1.0");
my $req = HTTP::Request->new(HEAD => $ARGV[0]);
my $res = $ua->request($req);
print "HTTP Result code: ".$res->code."\n\n";
print (($res->is_success) ? $res->headers->as_string() : $res->message);