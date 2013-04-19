#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Level1: Login
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es ermoeglicht den Benutzer sich einzuloggen bzw
#das Level1-Flag auf die Registrierungs-Seite zu setzen
#falls ein neuer Account erstellt werden soll

use CGI::Session;
use feature qw {switch};
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils;
use LoginContent;
use LoginDB;

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
	when('')				{#Zeige Auswahl/Registrierungsseite
							LoginContent::printIndex();
							}
							
	when('Check')			{#Ueberpruefe die Logindaten
							if( ($session->param('UserIdent') ne 'E-Mail Adresse') && $session->param('UserPassword') ne "" )
  									  {#Es wurde etwas eingegeben
  									  	#Hier wird ueberprueft ob der User&Passwort korrekt sind, mit dem Status(rueckgabewert) wird weiterverfahren
  									  	my $Level2 = LoginDB::login_User($session->param('UserIdent'),$session->param('UserPassword'));	
  									  	$session->param('ShowPage_Level2', $Level2);								  			
  									  }								
							else
							{#Eingabe war nicht vollstaending, Level2 wird geloescht und User darf es nochmal probieren
								$session->param('ShowPage_Level2', '');
							}
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
							}
	
	when('Valid')			{#Zeige das User eingeloggt wurde, setze zugehoehrige Rechte und trage Session-ID in Datenbank ein
							if(LoginDB::set_SessionID($session->param('UserIdent'),$session->id()) )
								{#Session-ID wurde erfolgreich gesetzt
									DebugUtils::html_testseite("Login war erfolgreich");
									#Hier werden die Rechte von der Datenbank ausgelesen und eingetragen
									my $AccessRights = LoginDB::get_AccessRights($session->param('UserIdent'));
									$session->param('AccessRights', $AccessRights); 
									#Mitarbeiter-Level wird in Session gespeichert (Mitarbeiter-Level gibt an, welches Ticket für den MA sichtbar ist)
									if($AccessRights ne "User") {
										my $qualification = LoginDB::get_MA_Level($session->param('UserIdent'));
										$session->param('Qualification', $qualification);
									}
									$session->param('ShowPage_Level1', $AccessRights);	#Entscheidungsbaum wird anhand der Zugriffsrechte aufgerufen
									$session->param('ShowPage_Level2', "");
									$session->flush();							
								}
							else
								{#Session-ID konnte NICHT eingetragen werden -> Setze Level2 auf Invalid (User darf es nochmal probieren)
									$session->param('ShowPage_Level2', "Invalid");
									$session->flush();
								}
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}
	
	when('Invalid')			{#Zeige das User/Passwort-Kombination nicht existiert, loesche Session und leite zur Root weiter
							DebugUtils::html_testseite("Login fehlgeschlagen!");
							$session->clear();
							$session->flush();
							print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
							}
}
