#!perl -w 

#Modul LoginDB soll folgende Fumktionen bereitstellen
#login_User -> Loggt den User ein falls vorhanden, ansonsten gibt die Fehlermeldung aus
#regist_User -> Registriert den User falls noch nicht vorhanden und alle Felder ausgefüllt, ansonten gib Fehlermeldung aus

package LoginDB;

use db_access;
use strict; 
use Digest::SHA qw(sha256_hex);


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
 
sub set_SessionID
{#Die Subroutine setzt in der Datenbank die aktuelle Session-ID zu dem gerade eingeloggten Benutzer
 #Uebergabeparameter: 1. Userident
 #					  2. Session_ID
 my $UserIdent = $_[0];
 my $SessionID = $_[1];
 my $result = db_access::set_Hash($UserIdent, $SessionID);
 return $result;
}

sub get_AccessRights
{#Die Subroutine holt über das db_access-Modul die Benutzerrechte des "mitgegebenen Benutzer-ID"
 #Uebergabeparameter: 1. UserIdent
 #Rückgabeparameter : Access-Rights von der Datenbank
 my $UserID = $_[0];
 my $AccessRights = db_access::get_AccessRights($UserID);
 return $AccessRights;
}

sub get_MA_Level
{#Holt die "Qualifikation" der Mitarbeiter aus der Datenbank
 #Wird später verwendet um zu bestimmen welcher Mitarbeiter welche Tickets bekommt
 #Uebergabeparameter: 1: UserIdent
 #Rueckgabeparameter: Qualifikation vom User (INT) ( Level 1 - 3 )
 my $UserIdent = $_[0];
 my $Result = db_access::get_MA_Level($UserIdent);
 return $Result;
}
1;