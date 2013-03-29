#!perl -w 

#Modul LoginDB soll folgende Fumktionen bereitstellen
#login_User -> Loggt den User ein falls vorhanden, ansonsten gibt die Fehlermeldung aus
#regist_User -> Registriert den User falls noch nicht vorhanden und alle Felder ausgefüllt, ansonten gib Fehlermeldung aus

package LoginDB;

use db_access 'valid_Login','insert_User','exist_User';
use strict; 
use Exporter;
use Digest::SHA qw(sha256_hex);

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(login_User regist_User);


 sub login_User
 {#Uebergabeparameter: Benutzername (Email-Adresse), Passwort (muss gehasht weitergegeben werden)
  #Ablauf: 1. Ueberpruefe ob der User existiert
  # 	   2. Ueberpruefe ob das Passwort richtig ist
  #		   3. Wenn alles passt, dann leite auf die "interne Oberflaeche weiter"
  
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