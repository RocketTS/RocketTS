#!perl -w 

#Leitet einfach nur weiter damit das Werte-Setzen im Cookie funktioniert

use CGI::Session;
use feature qw {switch};
use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an

 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;
# new session object, will get session ID from the query object
# will restore any existing session with the session ID in the query object  											
my $session = CGI::Session->new($cgi);
print $session->header();
$Parameter = $session->param('setContent');
if( $Parameter eq "content_Start")
{
	print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/User.cgi'});
}
else
{
	print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
}