#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 30.03.2013                    #
########################################
#Description: Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package UserDB;

use db_access;
use feature qw {switch};
use strict;
use HTML::Table;
use Digest::SHA qw(sha256_hex);


sub get_Tickets
{	#Aufruf: 	   get_Tickets("Email-Adresse", "Status");
	#Beschreibung: Diese Subroutine holt alle erstellten Tickets des Benutzers ab (Email-Adresse) die den übergebenen Status entsprechen (Neu, 
	#			   Offen, Geschlossen, In Bearbeitung), speichert diese in eine Tabelle
	#			   und gibt eine Referenz von diese Tabelle zurück
	#Rückgabewert: Referenz der Tickettabelle

	#Liefert eine HTML-Tabllen-Objekt zurueck
 	my $UserIdent = $_[0];
 	my $Status = $_[1];
 	my $ref_Ticketarray = db_access::get_Tickets($UserIdent);
 	#Hole das Ticketarray
 	my @Ticketarray = @$ref_Ticketarray;
 	
 	#Erstelle das TableObjekt
 	my $table = HTML::Table->new(-cols    => 2, 
    							 -border  => 0,
    							 -padding => 1,
    							 -width	 => '100%',
    							 -align   => 'center',
    							 -head => ['Erstelldatum', 'Betreff'],
 								 );
	
 	foreach my $array ( @{$ref_Ticketarray} ) 
 	{
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

 	$table->setColWidth(1, 200);	#Legt die Breite der ersten Spalte fest (200 Pixel)
 	$table->setColAlign(1, 'left');	#Erste Spalte wird links ausgerichtet
 	$table->setColAlign(2, 'left');	#zweite Spalte wird links ausgerichtet
 	return \$table;
}

sub show_Messages_from_Ticket
{	#Aufruf: 	   show_Messages_from_Ticket(TicketID, "Email-Adresse");
	#Beschreibung: Diese Subroutine holt sich über db_access alle Nachrichten, die zu einem Ticket gehören und speichert diese in einer HTML-Tabelle
	#Rückgabewert: Referenz auf die HTML-Tabelle

	my $TicketID = $_[0];
	my $UserIdent = $_[1];
	
	my $ref_Messagearray = db_access::get_Messages_from_Ticket($UserIdent, $TicketID);
	my @Messagearray = @$ref_Messagearray;
	
	#Erstelle das TableObjekt
	my $table = HTML::Table->new(-cols    => 3, 
    							 -border  => 0,
    							 -align   => 'left',
    							 -head => ['Erstelldatum', 'Benutzer', 'Nachricht'],
	 							 );

	 
	 foreach my $array ( @{$ref_Messagearray} ) 
	 {
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

sub changePassword
{	#Aufruf: 	   changePassword("Email-Adresse", "Altes_Passwort, "Neues_Passwort_1", "Neues_Passwort_2");
	#Beschreibung: Diese Subroutine überprüft ob alle Eingaben gemacht wurden, ob das "Alte Passwort" mit dem in der Datenbank übereinstimmt
	#			   ob, die beiden neuen Passwörter identisch sind, und ob das neue Passwort korrekt in die Datenbank eingetragen wurde
	#Rückgabewert: missing (Eine Eingabe fehlt)
	#			   not_equal (Die neuen Passwörter sind nicht identisch)
	#			   incorrect (Das alte Passwort stimmt nicht)
	#			   success (Das alte Passwort wurde erfolgreich überschrieben)
	#			   failed (Es trat beim Überschreiben des Passwortes in der Datenbank ein Fehler auf)
	
	#Zuerst wird ueberprueft ob alles eingegeben wurde, und ob Passwort 1 gleich dem Passwort 2 ist
	my($UserIdent,$oldPassword,$newPassword1,$newPassword2) = @_;
	my $oldPassword_hashed = sha256_hex($oldPassword);
	my $newPassword1_hashed = sha256_hex($newPassword1);
	my $newPassword2_hashed = sha256_hex($newPassword2);
	
	if($oldPassword eq "" || $newPassword1 eq "" || $newPassword2 eq "")
	{
		return "missing";
	}
	
	if($newPassword1 ne $newPassword2)
	{
		return "not_equal";
	}
	
	#Jetzt wird ueberprueft ob das alte eingegebenen Passwort zu dem UserIdent passt, dessen Passwort geändert werden soll
	if(! db_access::valid_Login($UserIdent, $oldPassword_hashed))
	{#Gibt true zurueck falls das Passwort passt, wird negiert
		return "incorrect";
	}
	
	#Jetzt darf das alte Passwort ueberschrieben werden
	if( db_access::change_Password($UserIdent, $newPassword1_hashed))
	{#Falls das setzten des neues Passwortes erfolgreich war
		return "success";
	}
	else
	{#ansonsten
		return "failed";
	}
}

sub deleteAccount
{	#Aufruf: 	   deleteAccount("Email-Adresse", "Passwort");
	#Beschreibung: Die Subroutine identifiziert die Echtheit des Benutzers durch die Passworteingabe und löscht dann den Benutzer aus dem System
	#Rückgabewert: missing (Passwort wurde zur Identifikation nicht eingegeben)
	#			   incorrect (Passwort wurde nicht korrekt eingegeben)
	#			   success (Der Account wurde erfolgreich gelöscht)
	#			   failed (Es trat bei dem Löschen aus dem System ein Fehler auf!)

	#Zuerst wird überprüft ob das Passwort eingegeben wurde
	my $UserIdent = $_[0];
	my $Password_hash = sha256_hex($_[1]);
	if($_[1] eq "")
	{
		return "missing";
	}
		
	#Jetzt wird überprüft ob das Passwort zum User passt, um dessen Identität zu bestätigen
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

sub changeEmail
{	#Aufruf: 	   changeEmail("Email-Adresse", "Passwort", "Neue_Email-Adresse");
	#Beschreibung: Diese Subroutine überprüft die Echtheit des Benutzers mit dem mitgegebenen Passwort und
	#			   ändert dann die Email-Adresse im System
	#Rückgabewert: missing_password (Passwort wurde nicht eingegeben)
	#			   missing_email (neue Email-Adresse wurde nicht eingegeben)
	#			   incorrect (Passwort das eingegeben wurde, war nicht korrekt)
	#			   success (Die neue Email-Adresse wurde erfolgreich in das System eingetragen)
	#			   failed (Es trat beim Eintragen der neuen Email-Adresse ein Fehler auf)
	
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

sub get_DropDownValues
{	#Aufruf: 	   get_DropDownValues("Tabellenname_in_der_Datenbank");
	#Beschreibung: Diese Subroutine dient als Schnittstelle zu dem Modul db_access
	#			   Es wird der Tabellenname übergeben, in der die DropDown-Values hinterlegt sind
	#Rückgabewert: Referenz auf Array, das die DropDown-Values enthält
	
	my $tabellenname = $_[0];
	my $referenz = db_access::get_DropDownValues($tabellenname);
	return $referenz;
}

sub create_Ticket
{	#Aufruf: 	   create_Ticket("Email", "Betreff", "Nachricht", "Auswahl_ID", "Priorität_ID");
	#Beschreibung: Diese Subroutine dient als Schnittstelle zu dem Modul db_access
	#			   Es wird damit ein neues Ticket in der Datenbank angelegt
	#Rückgabewert: boolschwer Wert (0=Fehler, 1=kein Fehler)

	my($Userident, $Betreff, $Message, $Auswahl_ID, $Prioritaet_ID) = @_;
	my $Status = db_access::create_Ticket($Userident,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID);
	return $Status;
}

sub answer_Ticket
{	#Aufruf: 	   answer_Ticket("Email-Adresse", "Ticket_ID", "Nachricht");
	#Beschreibung: Diese Subroutine dient als Schnittstelle zu dem Modul db_access
	#			   Es wird damit eine neue Nachricht an ein bestimmtes Ticket "angehängt"
	#Rückgabewert: boolschwer Wert (0=Fehler, 1=kein Fehler)

	my($Userident, $TicketID, $Message) = @_;
	my $Success = db_access::answer_Ticket($Userident,$TicketID,$Message);
	return $Success;
}

sub get_TicketStatus
{	#Aufruf: 	   get_TicketStatus("Ticket_ID");
	#Beschreibung: Diese Subroutine dient als Schnittstelle zu dem Modul db_access
	#			   Es wird damit der Status eines Tickets abgefragt
	#Rückgabewert: Neu (Ticket wurde neu erstellt)
	#			   Geschlossen (Ticket wurde geschlossen, kein Antworten mehr möglich)
	#			   In Bearbeitung (Das Ticket befindet sich nun in der Bearbeitung eines Mitarbeiters)
	
	my $TicketID = $_[0];
	my $Status = db_access::get_TicketStatus($TicketID);
	return $Status;
}
1;