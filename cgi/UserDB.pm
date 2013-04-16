#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 30.03.2013                    #
########################################
#Description: wird nur von UserContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package UserDB;

use db_access 'valid_Login','insert_User','exist_User','get_Messages_from_Ticket';
use feature qw {switch};
use strict;
use Exporter;
use HTML::Table;
use Digest::SHA qw(sha256_hex);

our @EXPORT_OK = qw(show_Tickets show_Messages_from_Ticket);

sub get_Tickets
{#1. Uebergabeparameter = UserIdent (Email)
 #2. Status (z.b. "Neu")
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 my $Status = $_[1];
 my $ref_Ticketarray = db_access::get_Tickets($UserIdent);
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray;
 	
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 2, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['Erstelldatum', 'Betreff'],
 );
	
 foreach my $array ( @{$ref_Ticketarray} ) {
 	 if( $Status eq 'Alle' || $array->[3] eq $Status)
 	 {	#Nur wenn das Ticket offen/bearbeitung/geschlossen ist solls angezeigt werden
		#Jetzt wird aus dem Topic ein Link generiert, 
	 	#welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 	my $LinkText = $array->[2];
	 	my $TicketID = $array->[0];
	 
	 	my $Link = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$TicketID&Level2=show_specTicket\" target=\"_self\">$LinkText</a>";
	  
	 	#Das Erstelldatum und der veränderte "TopicLink" werden der HTML-Tabelle hinzugefügt
	 	$table->addRow($array->[1], $Link);
 	 }
 }

 $table->setColWidth(1, 200);		#Legt die Breite der ersten Spalte fest (100 Pixel)
 $table->setColAlign(1, 'left');	#Erste Spalte wird zentriert dargestellt
 $table->setColAlign(2, 'left');	#zweite Spalte wird zentriert dargestellt
 return \$table;
}

sub show_Messages_from_Ticket{
	#1. Uebergabeparameter = TicketID
	#2. Uebergabeparameter = UserIdent
	#Zur Sicherheit wird zuerst geprueft ob der User sein eignes Ticket anschauen moechte
	#Danach werden alle Messages geholt diese in eine HTML-Tabelle verpackt und eine 
	#Referenz auf diese zurueckgegeben
	my $TicketID = $_[0];
	my $UserIdent = $_[1];
	
	my $ref_Messagearray = db_access::get_Messages_from_Ticket($UserIdent, $TicketID);
	my @Messagearray = @$ref_Messagearray;
	
	 #Erstelle das TableObjekt
	 my $table = HTML::Table->new( 
    	-cols    => 3, 
    	-border  => 0,
    #	-padding => 1,
   # 	-width	 => 970,
    	-align   => 'left',
    	-head => ['Erstelldatum', 'Benutzer', 'Nachricht'],
	 );

	 
	 foreach my $array ( @{$ref_Messagearray} ) {

	 my $Erstelldatum = $array->[1];
	 my $Author = $array->[0];
	 my $Message = $array->[2];
	 	  
	 #Das Erstelldatum und der veränderte "TopicLink" werden der HTML-Tabelle hinzugefügt
	 $table->addRow($Erstelldatum, $Author, $Message);
 	 }
 $table->setColWidth(1, 150);	#Legt die Breite der ersten Spalte fest (100 Pixel)
 $table->setColWidth(2, 200);	#Breite 2. Spalte
 $table->setColWidth(3, 550);	#Breite 3. Spalte

 return \$table;	
}

sub changePassword{
	#1. Uebergabeparameter = UserIdent
	#2. Uebergabeparamteer = Altes Passwort
	#3. Uebergabeparamter  = Neues Passwort 1
	#4. Uebergabeparameter = Neues Passwort 2
	#Rückgabe = Statusmeldungen (Fehlerstatus, oder alles ok)
	#Zuerst wird ueberprueft ob alles eingegeben wurde, und ob Passwort 1 gleich dem Passwort 2 ist
	my($UserIdent,$oldPassword,$newPassword1,$newPassword2) = @_;
	my $oldPassword_hashed = sha256_hex($oldPassword);
	my $newPassword1_hashed = sha256_hex($newPassword1);
	my $newPassword2_hashed = sha256_hex($newPassword2);
	
	if($oldPassword eq "" || $newPassword1 eq "" || $newPassword2 eq "")
	{
		return "changePassword_missing";
	}
	
	if($newPassword1 ne $newPassword2)
	{
		return "changePassword_not_equal";
	}
	
	#Jetzt wird ueberprueft ob das alte eingegebenen Passwort zu dem UserIdent passt, dessen Passwort geändert werden soll
	if(! db_access::valid_Login($UserIdent, $oldPassword_hashed))
	{#Gibt true zurueck falls das Passwort passt, wird negiert
		return "changePassword_incorrect";
	}
	
	#Jetzt darf das alte Passwort ueberschrieben werden
	if( db_access::change_Password($UserIdent, $newPassword1_hashed))
	{#Falls das setzten des neues Passwortes erfolgreich war
		return "changePassword_success";
	}
	else
	{#ansonsten
		return "changePassword_failed";
	}
}

sub deleteAccount{
	#1. Uebergabeparameter = UserIdent
	#2. Uebergabeparameter = Passwort
	#Rückgabe = Statusmeldungen (Fehlerstatus oder alles ok)
	#Zuerst wird überprüft ob das Passwort eingegeben wurde
	my $UserIdent = $_[0];
	my $Password_hash = sha256_hex($_[1]);
	if($_[1] eq "")
	{
		return "missing";
	}
		
	#Jetztwird überprüft ob das Passwort zum User passt, um dessen Identität zu bestätigen
	if(! db_access::valid_Login($UserIdent, $Password_hash))
	{#Gibt true zurueck falls das Passwort passt, wird negiert
		return "incorrect";
	}
	
	#Jetzt kann das User-Löschen-Procedure gestartet werden
	if(db_access::deleteAccount($UserIdent))
	{#War die Löschung erfolgreich
		return "success";	
	}
	else
	{
		return "failed";
	}
}

sub changeEmail{
	#1. Uebergabeparameter = UserIdent
	#2. Uebergabeparameter = Passwort
	#3. Uebergabeparameter = neue Email-Adresse
	#Rückgabe = Statusmeldungen (Fehlerstatus oder alles ok)
	#Zuerst wird überprüft ob das Passwort eingegeben wurde
	my $UserIdent = $_[0];
	my $Password_hash = sha256_hex($_[1]);
	my $newEmail = $_[2];
	if($_[1] eq "")
	{
		return "missing_password";
	}
	
	if($_[2] eq "")
	{
		return "missing_email";
	}
		
	#Jetztwird überprüft ob das Passwort zum User passt, um dessen Identität zu bestätigen
	if(! db_access::valid_Login($UserIdent, $Password_hash))
	{#Gibt true zurueck falls das Passwort passt, wird negiert
		return "incorrect";
	}
	
	#Jetzt kann die Email ändern Procedure gestartet werden
	if(db_access::changeEmail($UserIdent, $newEmail))
	{#War die Löschung erfolgreich
		return "success";	
	}
	else
	{
		return "failed";
	}
}