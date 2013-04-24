#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Stellt Funktionen bereit
#um Inhalte von der User-Website darzustellen

package UserContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use UserDB;
use HTML::Table;
use feature qw {switch};


sub print_User_Testseite
{	#Aufruf: 	   print_User_Testseite("Dieser Text soll angezeigt werden");
	#Beschreibung: Diese Subroutine gibt den übergebenen Text als HTML-Seite auf
	#Rückgabewert: Keiner
	
	my $text = $_[0];
	my $cgi = CGI->new();
	print $cgi->h1($text);
}

sub print_Index
{	#Aufruf: 	   printIndex();
	#Beschreibung: Diese Subroutine zeigt die Startseite des Userbereiches
	#Rückgabewert: Keiner
	my $cgi = CGI->new();
	my $session = CGI::Session->new($cgi);
    #print $cgi->h1( $cgi->center("Startseite von User Rechte: ".$session->param('AccessRights')));
    print $cgi->h1( $cgi->center("Startseite von " .$session->param('UserIdent') . " Rechte: ".$session->param('AccessRights'))); 
}

sub print_createTicket
{	#Aufruf: 	   print_createTicket();
	#Beschreibung: Diese Subroutine gibt den HTML-Code für die Ticketerstellung aus
	#			   Die Punkte für das Dropdown-Menü (Kategorie) wird dabei aus der Datenbank ausgelesen
	#Rückgabewert: Keiner
	
	
	#Jetzt werden die Values für das Dropdown-Menü aus der Datenbank geholt
	#Übergabeparameter: Tabellenname, in dem sich die Werte befinden (auswahlkriterien)
	my $ref_DropDown = UserDB::get_DropDownValues("auswahlkriterien");
	
 	my $cgi = CGI->new();
	print $cgi->start_html();
	print $cgi->h2("Neues Ticket erstellen");
	
	print "<table>";
	print "<tr>";
	print "<td>";	
	
	print "</td></tr>";
	print "<tr>";
	print "<td>";
 	print $cgi->strong("Betreff\t");
 	print "</td>";
 	print "<td>";
	 
	 
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
 	
 	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_createTicket');
	 				   
	
	 
	print $cgi->textfield(-name=>'input_Betreff',
	 					  -value=>'',
	 					  -size=>50,
	 					  -maxlength=>50);

	#Gebe das DropDown-Menü aus
	UserContent::print_dropDown("input_Categorie",$ref_DropDown); 
	print "</td></tr>";
	print "<tr><td>";
	print $cgi->strong("Nachricht\t");	
	
	print "</td><td>";
	 						
	print $cgi->textarea(-name=>'input_Message',
	 						   -value=>'',
	 						   -cols=>70,
	 						   -rows=>10);
	print "</td></tr>";
	print "<tr><td></td><td>";
	
	print $cgi->submit("Erstellen");
	print "</td></tr>";
	print "</table>";
	print $cgi->end_form();
}

sub print_submit_createTicket
{	#Aufruf: 	   print_submit_createTicket("Username", "Betreff", "Nachricht", "Auswahl_ID", "Priorität_ID");
	#Beschreibung: Diese Subroutine versucht das Ticket in die Datenbank einzutragen, und gibt danach
	#			   das Ergebnis als HTML-Code aus (Entweder es hat funktioniert oder nicht)
	#Rückgabewert: Keiner
 	my($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID) = @_;
 	my $success = UserDB::create_Ticket($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID);
 	if($success != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich uebermittelt!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht uebermittelt werden!");
 	}
 }
 
sub print_answerTicket
{	#Aufruf: 	   print_answerTicket("Email", "Ticket_ID", "Nachrichttext");
	#Beschreibung: Diese Subroutine versucht eine Ticketantwort in die Datenbank einzutragen
	#			   Dabei wird das Ergebnis (Erfolg oder Misserfolg) in dem Browser ausgegeben und automatisch
	#			   nach 3 Sekunden auf die Ticketverlaufsansicht weitergeleitet
	#Rückgabewert: Keiner

  	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
 	my($Username,$TicketID,$Message) = @_;
 	my $success = UserDB::answer_Ticket($Username,$TicketID,$Message);
 	if($success != 0)
 	{
 		print_User_Testseite("Antwort wurde erfolgreich uebermittelt!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Antwort konnte nicht uebermittelt werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

}
 
sub print_show_ownTickets
{	#Aufruf: 	   print_show_ownTickets("Status");
	#Beschreibung: Diese Subroutine zeigt alle vom Benutzer erstellten Tickets im Browser an, welche den Status erfüllen,
	#			   der dieser Subroutine mitgeliefert wurde ("Alle", "Neu", "Bearbeitung", "Geschlossen")
	#Rückgabewert: Keiner

 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
	my $Status = $_[0];


	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	

	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = UserDB::get_Tickets($session->param('UserIdent'), $Status);
	my $table = $$ref_table;
	
	given ($Status)
	{
		when( 'Alle' )			{print $cgi->h1("Übersicht aller erstellten Tickets");}
		when( 'Neu' )			{print $cgi->h1("Übersicht der unbearbeiteten Tickets");}
		when( 'Bearbeitung' )	{print $cgi->h1("Übersicht der Tickets in Bearbeitung");}
		when( 'Geschlossen' )	{print $cgi->h1("Übersicht der geschlossenen Tickets");}
	}
	

	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der Länge des Inhalts der Zelle gegeben
 	$table->setClass("table_tickets");				#Verwende das Definierte Layout das in der CSS-Datei definiert ist
	
	print $table->getTable();	
	
 }
 
 
sub print_show_specTicket
{	#Aufruf: 	   print_show_specTicket("Status");
	#Beschreibung: Diese Subroutine zeigt den Nachrichtenverlauf von genau einem Ticket. Die TicketID, welche angezeigt
	#			   werden soll, wird aus der Session-Variable "$TicketID" geholt
	#			   Am Ende der Nachrichten wird ein Antwortfeld angezeigt, wenn das Ticket NICHT geschlossen ist!
	#Rückgabewert: Keiner

 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
	
	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	my $TicketID = $session->param('specificTicket');
	my $TicketStatus = UserDB::get_TicketStatus($TicketID);
	
	#Hole das Array, welche den Nachrichtenverlauf beinhaltet
	my $ref_table = UserDB::show_Messages_from_Ticket($TicketID,$session->param('UserIdent'));
	my $table = $$ref_table;
	
	$table->setAttr('style="table-layout:fixed"'); 	#Damit wird der ColWidth Vorrang vor der Länge des Inhalts der Zelle gegeben
 	$table->setClass("table_tickets");				#Verwende das Definierte Layout das in der CSS-Datei definiert ist
	
	#Gebe den Nachrichtenverlauf aus
	print $table->getTable();	
	
	if($TicketStatus ne "Geschlossen")
	{ 	
		#Zeige das "Antwortformular", wenn der Ticketstatus NICHT "Geschlossen" ist
		print "<table><tr><td>";
		print $cgi->h2("Antwort");
		print "<table></td></tr><tr><td>";
	
	 
		print $cgi->start_form({-method => "POST",
	 							-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 							-target => '_self'
	 						 	});
	 
 		print $cgi->hidden(-name=>'Level2',
	 				    	-value=>'submit_answerTicket');
	 				   	
		print $cgi->textarea(-name=>'input_Message',
	 						 -value=>'',
	 						 -cols=>70,
	 						 -rows=>10);
	
		print "</td></tr><tr><td>";
		print $cgi->submit("Abschicken");
		print "</td></tr></table>";
	}
	else
	{
		print $cgi->h1("Ticket geschlossen!");
	}
	print $cgi->end_form();
 }
 
sub print_show_Einstellungen
{	#Aufruf: 	   print_show_Einstellungen("Bereich");
	#Beschreibung: Diese Subroutine gibt den "Einstellungsbereich" der Website aus.
	#			 : Mögliche Bereiche sind "Password", "Email", "delete_Account"
	#Rückgabewert: Keiner
 	
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
	#In $Status wird angegeben welcher Einstellungsbereich ausgegeben werden soll
	my $Status = $_[0];
		
	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	
	#Zeige den Menupunkt an, der ausgewaehlt wurde
	
	given ($Status)
	{
		when( 'Password' )			{print $cgi->h1("Ändern des Passwortes");
									 print $cgi->start_form({-method => "POST",
	 								 -action => "/cgi-bin/rocket/SaveFormData.cgi",
	 								 -target => '_self'
	 						 								});	 
	 								 print $cgi->hidden(-name=>'Level2',
	 				  									-value=>'changePassword');
	 				  				 print $cgi->hidden(-name=>'Level3',
	 				  									-value=>'checkPassword'); 	 				   
	 								 print "<table><tr><td>";
									 print $cgi->strong("Altes Passwort\t");
									 print "</td><td>";			 						
	 								 print $cgi->password_field(-name=>'input_Password',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 #print $cgi->br();									 
									 print "</td></tr><tr><td>";
									 print $cgi->strong("Neues Passwort\t");
									 print "</td><td>";									 
									 print $cgi->password_field(-name=>'input_Password_new1',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 #print $cgi->br();									 
									 print "</td></tr><tr><td>";
									 print $cgi->strong("Neues Passwort wiederholen\t");
									 print "</td><td>";									 
									 print $cgi->password_field(-name=>'input_Password_new2',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 print "</td></tr><tr><td></td><td>";
									 #print $cgi->br();									 
	 								 print $cgi->submit("Übernehmen");
									 print $cgi->end_form();
									 print "</td></tr></table>";
									}
		when( 'Email' )				{print $cgi->h1("Ändern der Email-Adresse");
									 print "<table><tr><td>";
									 print $cgi->start_form({-method => "POST",
	 								 -action => "/cgi-bin/rocket/SaveFormData.cgi",
	 								 -target => '_self'
	 						 								});	 
	 								 print $cgi->hidden(-name=>'Level2',
	 				  									-value=>'changeEmail'); 
	 				  				 print $cgi->hidden(-name=>'Level3',
	 				  									-value=>'checkPassword');				   
	 
									 print $cgi->strong("Neues Email-Adresse\t");
									 print "</td><td>";		 						
	 								 print $cgi->textfield(-name=>'input_Email_new',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 #print $cgi->br();	
									 print "</td></tr><tr><td>";								 
									 print $cgi->strong("Passwort bestätigen\t");
									 print "</td><td>";										 
									 print $cgi->password_field(-name=>'input_Password_new1',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 #print $cgi->br();	
									 print "</td></tr><tr><td></td><td>";							 									 
	 								 print $cgi->submit("Übernehmen");
									 print $cgi->end_form();
									 print "</td></tr></table>";
									}
		when( 'delete_Account' )	{print $cgi->h1("Löschen des eigenen Accounts");
									 print "<p>Zur Bestätigung bitte das Passwort eingeben</p>";
									 print $cgi->start_form({-method => "POST",
	 								 -action => "/cgi-bin/rocket/SaveFormData.cgi",
	 								 -target => '_self'
	 						 								});	 
	 								 print $cgi->hidden(-name=>'Level2',
	 				  									-value=>'deleteAccount'); 		
	 								
	 								 print $cgi->hidden(-name=>'Level3',
	 				  									-value=>'checkPassword');		   
	 
									 print $cgi->strong("Passwort\t");		 						
	 								 print $cgi->password_field(-name=>'input_Password',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 print $cgi->br();									 
									 	 
	 								 print $cgi->submit("Account löschen!");
									 print $cgi->end_form();
									}
	}	
}
 
sub print_dropDown
{	#Aufruf: 	   print_dropDown("dropDown-Variablenname", $Referenz_auf_Tabelle);
	#Beschreibung: Diese Subroutine gibt den HTML-Code eines DropDown-Menüs aus.
	#			   Unter "dropDown-Variablenname" ist der ausgewählte Wert, später im CGI-Object greifbar (cgi->param("dropDown-Variablenname")
	#			   Die Tabelle, welche mit den anzuzeigenen Werten übergeben wird muss folgenden Aufbau haben:
	#			   1 => Hans
  	#		  	   2 => Karl
  	#		       3 => Kunz
	#Rückgabewert: Keiner

  	my $name = $_[0];
  	my $ref_Array = $_[1];
  	
  	#Hier wird jetzt der HTML-Code ausgegeben
  	print "<select name=\"$name\">";
  	foreach my $eintrag ( @{$ref_Array} ) 
  	{
  		print "<option value=\"$eintrag->[0]\">$eintrag->[1]";	
 	}
 	print "</select> ";
 }
 1;