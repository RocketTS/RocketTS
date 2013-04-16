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
use LoginDB 'regist_User';
use RegistrationDB;


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
							my $Level2 = RegistrationDB::regist_User($session->param('RegistrationVorname'),
  															 $session->param('RegistrationNachname'),
  															 $session->param('RegistrationEmail'),
  															 $session->param('RegistrationPassword1'),
  															 $session->param('RegistrationPassword2') 
  																			  		);
  							$session->param('ShowPage_Level2', $Level2);
  							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
							}
							
	when('Valid')			{#Zeige das neuer Benutzer angelegt wurde, loesche die Session und ermoegliche Benutzer sich einzuloggen
							DebugUtils::html_testseite("Registrierung erfolgreich");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}

	when('Invalid')			{#Zeige das neuer Benutzer NICHT angelegt werden kann, loesche die Session und ermoegliche Benutzer sich neu zu registrieren
							DebugUtils::html_testseite("Registrierung fehlgeschlagen");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}
							
	when('Textfields_incomplete'){#Zeige das neuer Benutzer NICHT angelegt werden kann, loesche die Session und ermoegliche Benutzer sich neu zu registrieren
							DebugUtils::html_testseite("Textfelder nicht alle ausgefüllt");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}	
													
	when('User_exists_already'){#Zeige das neuer Benutzer NICHT angelegt werden kann, loesche die Session und ermoegliche Benutzer sich neu zu registrieren
							DebugUtils::html_testseite("Den Benutzer gibt es bereits");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}	
		
	when('Passwords_not_equal'){#Zeige das neuer Benutzer NICHT angelegt werden kann, loesche die Session und ermoegliche Benutzer sich neu zu registrieren
							DebugUtils::html_testseite("Passwörter waren nicht identisch!");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}		
							
}