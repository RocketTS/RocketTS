#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Stellt Funktionen bereit
#um Inhalte von der User-Website darzu
#stellen

package UserContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Exporter;
use db_access 'create_Ticket';
use UserDB 'get_Tickets';
use HTML::Table;
use feature qw {switch};



our @EXPORT_OK = qw(print_createTicket print_Punkt2 print_Punkt3 print_Punkt4 print_Index print_submit_createTicket print_show_specTicket
					print_answerTicket);




sub print_User_Testseite
{#Uebergabeparameter: String der ausgegeben werden soll
 #Diese Subroutine ist für den Content-Bereich der Useransicht angepasst
	my $text = $_[0];
	my $cgi = CGI->new();
	print $cgi->h1($text);
  	1;		
 }

sub print_Index
{
	my $cgi = CGI->new();
	my $session = CGI::Session->new($cgi);
    print $cgi->h1( $cgi->center("Startseite von User Rechte: ".$session->param('AccessRights')));
	1;  
}

sub print_createTicket
{
	#Jetzt werden die Values für das Dropdown-Menü aus der Datenbank geholt
	my $ref_DropDown = db_access::get_DropDownValues("auswahlkriterien");
	
 	my $cgi = CGI->new();
		
	print $cgi->start_html();
	print $cgi->h2("Neues Ticket erstellen");
	 
 
	 
	 
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	
	#Gebe das DropDown-Menü aus
	UserContent::print_dropDown("input_Categorie",$ref_DropDown);
	print $cgi->br();
 	
 	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_createTicket');
	 				   
	print $cgi->strong("Betreff\t");
	 
	print $cgi->textfield(-name=>'input_Betreff',
	 					  -value=>'',
	 					  -size=>50,
	 					  -maxlength=>50);
	print $cgi->br();
	 
	print $cgi->strong("Nachricht\t");	
	 						
	print $cgi->textarea(-name=>'input_Message',
	 						   -value=>'',
	 						   -cols=>70,
	 						   -rows=>10);
	print $cgi->br();
	print $cgi->submit("Erstellen");
	print $cgi->end_form();
}

 sub print_submit_createTicket
 {#Subroutine versucht das Ticket in die Datenbank einzutragen
 	my($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID) = @_;
 	my $success = db_access::create_Ticket($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID);
 	if($success != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich uebermittelt!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht uebermittelt werden!");
 	}
 	1;
 }
 
  sub print_answerTicket
 {#Subroutine versucht das Ticket in die Datenbank einzutragen
  	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
 	my($Username,$TicketID,$Message) = @_;
 	my $success = db_access::answer_Ticket($Username,$TicketID,$Message);
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
 {#Alle von dem User erstellten Tickets werden anzeigt (Erstmal nur das Ticket ohne nachfolgenden Messages)
  #Uebergabeparameter 1: Status (Damit ist der Status des Tickets gemeint, bsp Neu, Bearbeitung, Geschlossen, ...
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
{#Ein bestimmtes von dem User erstellten Tickets wird Verlaufsmäßig angezeigt
 #Dabei soll der User eine neue Message anhängen/antworten können
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	my $TicketID = $session->param('specificTicket');
	
	
	print $cgi->h1("Das Ticket mit der ID $TicketID wird nachfolgend im \"Verlaufsmodus\" angezeigt!");
	my $ref_table = UserDB::show_Messages_from_Ticket($TicketID,$session->param('UserIdent'));
	my $table = $$ref_table;
	
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der Länge des Inhalts der Zelle gegeben
 	$table->setClass("table_tickets");				#Verwende das Definierte Layout das in der CSS-Datei definiert ist
	
	print $table->getTable();	
	
	#Zeige das "Antwortformular"
	print $cgi->h2("Antwort");
	 
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	 
 	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_answerTicket');
	 				   
	 
	print $cgi->strong("Nachricht\t");	
	 						
	print $cgi->textarea(-name=>'input_Message',
	 						   -value=>'',
	 						   -cols=>70,
	 						   -rows=>10);
	print $cgi->br();
	print $cgi->submit("Abschicken");
	print $cgi->end_form();
 }
 
 sub print_show_Einstellungen
 {
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;
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
	 
									 print $cgi->strong("Altes Passwort\t");		 						
	 								 print $cgi->password_field(-name=>'input_Password',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 print $cgi->br();									 
									 print $cgi->strong("Neues Passwort\t");									 
									 print $cgi->password_field(-name=>'input_Password_new1',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 print $cgi->br();									 
									 print $cgi->strong("Neues Passwort wiederholen\t");									 
									 print $cgi->password_field(-name=>'input_Password_new2',
	 														    -value=>'',
	 						 								    -size=>25,
	 						 								    -maxlength=>50);
									 print $cgi->br();									 
	 								 print $cgi->submit("Übernehmen");
									 print $cgi->end_form();
									}
		when( 'Email' )				{print $cgi->h1("Ändern der Email-Adresse");}
		when( 'delete_Account' )	{print $cgi->h1("Account löschen");}
	}
	
 }
 
 sub print_dropDown
 {	#Dieses Modul soll einfach ein DropDown ausgeben
  	#Uebergabeparameter: 1. Der Variablenname mit dem spaeter die Value identifizierbar ist
  	#					 2. gehashtes Array
  	#Beispiel 1 => Hans
  	#		  2 => Karl
  	#		  3 => Kunz
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