#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 06.04.2013                    #
########################################
#Description: Level1: Logout
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es ermoeglicht den Benutzer sich auszuloggen
#Dabei wird in der Datenbank der Session-Key ausgetragen
#und die Benutzersession auf dem Webserver gelöscht

use CGI::Session;
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils 'html_testseite';
use db_access 'del_Hash';

#########################################
#Instanzvariablen						#
#########################################

#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
#mit der Session-ID
my $cgi = new CGI;

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
#User her
my $session = CGI::Session->new($cgi);


#Ausgabe des Headers
print $session->header();

#Jetzt wird die Session-ID in der Datenbank gelöscht

my $deleted = db_access::del_Hash($session->param('UserIdent'));

if($deleted != 0)
{
	print $cgi->h1("Session-ID wurde gelöscht!");
}
else
{
	print $cgi->h1("Fehler beim Löschen der Session-ID");
}

#Danach wird die komplette Serverseitige Session gelöscht

$session->delete();
$session->flush();

print $cgi->h1("Sie werden nun ausgeloggt und auf die Startseite weitergeleitet!");
print $cgi->meta({-http_equiv => 'REFRESH', -content => '2; /cgi-bin/rocket/Rocket.cgi'});
