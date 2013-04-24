#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 30.03.2013                    #
########################################
#Description: wird nur von Registration.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package RegistrationDB;

use db_access;
use strict;
use Digest::SHA qw(sha256_hex);


sub regist_User
{ 	#Aufruf: 	   regist_User("Vorname", "Nachname", "Email", "Passwort_1", "Passwort_2");
	#Beschreibung: Diese Subroutine trägt einen neuen Benutzer in die Datenbank ein.
	#			   Zuerst wird überprüft ob die 2 eingegebenen Passwörter identisch sind
	#			   Danach wird getestet ob der Benutzer schon existiert, falls nein wird der Benutzer erstellt
	#Rückgabewert: Textfields_incomplete (Es wurden nicht alle Eingabefelder ausgefüllt)
	#			   Passwords_not_equal (Die beiden Passwörter waren nicht identsich)
	#			   User_exists_already (Den Benutzer gibt es schon in der Datenbank)
	#			   Invalid (Es trat ein Fehler in der Datenbank beim Erstellen auf)
	#			   Valid (Es wurde ohne Fehler der Benutzer in der Datenbank erstellt)

  	my $Vorname = $_[0];
 	my $Nachname = $_[1];
  	my $Email = $_[2];
 	my $Passwort1 = sha256_hex($_[3]);
  	my $Passwort2 = sha256_hex($_[4]);
	
	#Pruefe ob alle Felder ausgefuellt wurden
  
  	if($Vorname eq '' || $Nachname eq '' || $Email eq '' || $Passwort1 eq '' || $Passwort2 eq '' )
  	{
  		return "Textfields_incomplete";
  	}
  
  	if($Passwort1 eq $Passwort2)
  	{#Passwort ist identisch
		if(! db_access::exist_User($Email) )
		{#Benutzer gibt es noch nicht, also darf er erstellt werden
			if( db_access::insert_User($Nachname, $Vorname, $Email, $Passwort1) )
		  	{#Benutzer wurde erfolgreich hinzugefuegt		  	 	
		  		return "Valid";
		  	}
		  	else
		  	{#Es trat ein Fehler auf als der Benutzer hinzugefuegt werden sollte
		  		return "Invalid";
		  	}
		}
		else
		{#Benutzer gibt es leider schon
			return "User_exists_already";
		}
	}
  	else
  	{#Passwort wurde nicht identisch eingegeben
  		return "Passwords_not_equal";
  	}
 }
 1;