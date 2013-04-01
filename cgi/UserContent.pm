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



our @EXPORT_OK = qw(print_createTicket print_Punkt2 print_Punkt3 print_Punkt4 print_Index print_submit_createTicket print_show_specTicket);




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
 	my $cgi = CGI->new();
		
	print $cgi->start_html();
	print $cgi->h2("Neues Ticket erstellen");
	 
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	 
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
 
 sub print_show_ownTickets
 {#Alle von dem User erstellten Tickets werden anzeigt (Erstmal nur das Ticket ohne nachfolgenden Messages)
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;


	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	

	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = UserDB::get_Tickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("Übersicht der erstellten Tickets");

	
	print $table->getTable();	
	
	
 }
 
 sub print_show_specTicket
{#Ein bestimmtes von dem User erstellten Tickets wird Verlaufsmäßig angezeigt
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
	print $table->getTable();	
 }