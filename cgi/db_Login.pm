#!"C:\xampp\perl\bin\perl.exe" -w 

#Modul db_Login.pm soll folgende Fumktionen bereitstellen
#login_User -> Loggt den User ein falls vorhanden, ansonsten gibt die Fehlermeldung aus
#regist_User -> Registriert den User falls noch nicht vorhanden und alle Felder ausgefüllt, ansonten gib Fehlermeldung aus

package db_Login;

use db_access 'valid_Login','insert_User','exist_User';
use strict; 
use Exporter;
use Digest::MD5  qw(md5_hex);

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(login_User regist_User);


 sub login_User
 {#Uebergabeparameter: Benutzername (Email-Adresse), Passwort (muss gehasht weitergegeben werden)
  #Ablauf: 1. Ueberpruefe ob der User existiert
  # 	   2. Ueberpruefe ob das Passwort richtig ist
  #		   3. Wenn alles passt, dann leite auf die "interne Oberflaeche weiter"
  
  my $Username = $_[0];
  my $Password_hashed = md5_hex($_[1]);

  if( db_access->exist_User($Username) )
  {#Username ist vorhanden, jetzt kann getestet werden ob das Passwort dazupasst
  	if( db_access->valid_User($Username, $Password_hashed) )
  	{#Login erfolgreich, Passwort hat gepasst!
  		#Hier wird auf den "internen Bereich" weitergeleitet
  	}
  	#Passwort stimmte nicht
  }
  #Username nicht vorhanden
  #Fehlerfall koennte getrennt behandelt werden, aus Datenschutzgruenden wird aber nur "Login fehlgeschlagen angezeigt"
 }