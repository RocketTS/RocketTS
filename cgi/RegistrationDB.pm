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
 {#Uebergabeparameter: 1. Vorname, 2. Nachname, 3. Email, 4. Passwort1, 5. Passwort2
  #Ablauf: 1. Ueberpruefe ob das Passwort 2mal richtig eingegeben wurde
  #		   2. Ueberpruefe ob der User schon existiert
  #		   3. Wenn alles passt, dann leite die Anfrage weiter und erstelle den User
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