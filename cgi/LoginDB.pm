#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Beschreibung: Das Modul stellt Subroutinen bereit, die benötigt werden um einen User
#			   korrekt einzuloggen und benötigte Informationen aus der DB zu holen

package LoginDB;

use db_access;
use strict; 
use Digest::SHA qw(sha256_hex);


 sub login_User
 {	#Aufruf: 	   login_User("Benutzername", "Passwort");
	#Beschreibung: Die Funktion überprüft ob Benutzername und Passwort korrekt sind, und loggt diesen
	#			   User ein
	#Rückgabewert: Valid (Login war erfolgreich, Passwort war korrekt)
	#			 : Invalid (Passwort war nicht korrekt/Username wurde in der Datenbank nicht gefunden)

	my $Username = $_[0];
  	my $Password_hashed = sha256_hex($_[1]);

  	if( db_access::exist_User($Username) )
  	{#Username ist vorhanden, jetzt kann getestet werden ob das Passwort dazupasst
  		if( db_access::valid_Login($Username, $Password_hashed) )
  		{#Login erfolgreich, Passwort hat gepasst!
  		 #Hier wird auf den "internen Bereich" weitergeleitet
  			return "Valid";
  		}
  		#Passwort stimmte nicht
  		return "Invalid";
  	}
  	#Username nicht vorhanden
  	#Fehlerfall koennte getrennt behandelt werden, aus Datenschutzgruenden wird aber nur "Login fehlgeschlagen angezeigt"
  	return "Invalid";
 }
 
sub set_SessionID
{	#Aufruf: 	   set_SessionID("Benutzername","SessionID");
	#Beschreibung: Die Subroutine setzt in der Datenbank die aktuelle Session-ID zu dem zugehörigen Benutzer
	#Rückgabewert: 0 (Es trat ein Problem beim Eintragen in die Datenbank auf)
	#			 : 1 (Die SessionID wurde korrekt in die Datenbank eingetragen)
	
 	my $UserIdent = $_[0];
 	my $SessionID = $_[1];
 	my $result = db_access::set_Hash($UserIdent, $SessionID);
 	return $result;
}

sub get_AccessRights
{	#Aufruf: 	   get_AccessRights("Benutzername");
	#Beschreibung: Die Subroutine fragt die Benutzerrechte des Users in der Datenbank ab
	#Rückgabewert: User (Zugriffsrechte = User)
	#			 : Mitarbeiter (Zugriffsrechte = Mitarbeiter)
	#			 : Administrator (Zugriffsrechte = Administrator)

 	my $UserID = $_[0];
 	my $AccessRights = db_access::get_AccessRights($UserID);
 	return $AccessRights;
}

sub get_MA_Level
{	#Aufruf: 	   get_MA_Level("Benutzername");
	#Beschreibung: Die Subroutine fragt die Qualifikation des Mitarbeiters in der Datenbank ab
	#Rückgabewert: 1 (Hohe Qualifikation)
	#			 : 2 (Mittlere Qualifikation)
	#			 : 3 (Niedrige Qualifikation)

 	my $UserIdent = $_[0];
 	my $Result = db_access::get_MA_Level($UserIdent);
 	return $Result;
}
1;