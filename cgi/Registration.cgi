#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Level1: Registration
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es ermoeglicht die Erstellung eines Accounts durch
#den Benutzer

use CGI::Session;
use feature qw {switch};
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils 'html_testseite';
use RegistrationContent 'printIndex';


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

#Jetzt wird je nach showPage_Level2 entschieden wohin der Aufruf
#weitergeleitet wird

given ($session->param('ShowPage_Level2'))
{
	when('')				{#Zeige Registrierungsseite
							RegistrationContent::printIndex();
							}
	
	when('Check')			{#Pruefe ob der neue Benutzer angelegt werden kann
							DebugUtils::html_testseite("Registrierung wird geprüft");
							}
							
	when('Valid')			{#Zeige das neuer Benutzer angelegt wurde, loesche die Session und ermoegliche Benutzer sich einzuloggen
							}

	when('Invalid')			{#Zeige das neuer Benutzer NICHT angelegt werden kann, loesche die Session und ermoegliche Benutzer sich neu zu registrieren
							}
							
	
							
}