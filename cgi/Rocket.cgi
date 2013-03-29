#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Root
#Dieses Script wird bei jeder Aktion aufgerufen
#und entscheidet ob die Session gültig ist, und
#leitet den User weiter
#Es wird lediglich ein HTTP-Header erstellt und 
#danach gleich auf eine weitere Seite umgeleitet

use CGI::Session;
use feature qw {switch};
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils 'html_testseite';

#########################################
#Instanzvariablen						#
#########################################

#Erstelle ein neues CGI-Objekt und hole falls vorhanden den Cookie
#mit der Session-ID
my $cgi = new CGI;

#Erstelle eine neue Session, oder falls ein Cookie vorhanden war
#stell das Session-Objekt wieder her
my $session = CGI::Session->new($cgi);

#Falls eine Neue Session erstellt wurde, übermittel die neue Session-ID
#dem Clienten. Falls eine vorherige Session wiederhergestellt wurde
#wird die "alte" Session-ID uebermittelt
print $session->header();

#Ueberpruefe ob eine komplett neue Session erstellt wurde
#oder ob eine vorherige wiederhergestellt worden ist
#Falls neu, dann initialisiere die benötigten Variablen
if($session->param('ShowPage_Level1') eq '' )
{#Es handelt sich um eine komplett neue Session
	$session->param('ShowPage_Level1', '');
	$session->param('ShowPage_Level2', '');
	$session->param('ShowPage_Level3', '');
	$session->param('UserIdent', '');
	$session->param('UserPassword', '');
	$session->param('AccessRights', "None");

 #Speichere die neuen Werte im Session-Object
 	$session->flush();
}

#Jetzt wird je nach showPage_Level1 entschieden wohin der Aufruf
#weitergeleitet wird


given ($session->param('ShowPage_Level1'))
{
	when('')				{#Zum Login-Script
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Login.cgi'});
							}
							
	when('Login')			{#Zum Login-Script
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Login.cgi'});
							}
	
	when("Registration")	{#Zum Registration-Script
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Registration.cgi'});
							}
	
	when('User')			{#Zum User-Script
							DebugUtils::html_testseite("User");
							}
}
