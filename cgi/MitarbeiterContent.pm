#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 02.04.2013                    #
########################################
#Description: Stellt Funktionen bereit um Inhalte von der Mitarbeiter-Website darzustellen

package MitarbeiterContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Exporter;
use db_access 'create_Ticket';
use MitarbeiterDB 'get_allnewTickets','get_allinprocessTickets','get_allclosedTickets';
use HTML::Table;
use myGraph 'print_Statistik_TicketStatus';


our @EXPORT_OK = qw(print_show_newTickets print_show_inprocessTickets print_show_History print_show_Statistik print_show_User 
					print_show_inprocessTickets print_show_History print_Statistik print_answerTicket);




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
    print $cgi->h1( $cgi->center("Startseite von Mitarbeiter Rechte: ".$session->param('AccessRights')));
	1;  
}
 
 sub print_show_newTickets
 {#Alle von neu erstellten Tickets werden anzeigt
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = MitarbeiterDB::get_allnewTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("Übersicht der neu erstellten Tickets");

	$table->setClass("table_tickets");
	print $table->getTable();	
	
	
 }
  sub print_show_inprocessTickets
 {#Alle von neu erstellten Tickets werden anzeigt
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = MitarbeiterDB::get_allinprocessTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("Übersicht der Tickets in Bearbeitung");

	$table->setClass("table_tickets");
	print $table->getTable();	
	
	
 }
 
   sub print_show_History
 {#Alle von neu erstellten Tickets werden anzeigt
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = MitarbeiterDB::get_allclosedTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("Übersicht der Tickets in Bearbeitung");

	$table->setClass("table_tickets");
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
	my $ref_table = MitarbeiterDB::show_Messages_from_Ticket($TicketID,$session->param('UserIdent'));
	my $table = $$ref_table;
	$table->setClass("table_tickets");
	print $table->getTable();	
	print $cgi->br;
	
	#Anzeigen des Übernehmen-Buttons
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_assumeTicket'); 				   
	print $cgi->submit("Übernehmen");
	print "onclick=\"this.form['sub'].disabled=true";
	print $cgi->end_form();
	print "<input type=\"submit\" name=\"test\" value=\"Submit\" disabled>";
	#Anzeigen des Weiterleiten-Buttons
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_forwardTicket');
	print $cgi->submit("Weiterleiten");
	print $cgi->end_form();
	
	#Anzeigen des Schließen-Buttons
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	print $cgi->hidden(-name=>'Level2',
	 				   -value=>'submit_closeTicket');
	print $cgi->submit("Schliessen");
	print $cgi->end_form();
	
	
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
 
sub print_answerTicket {  #Subroutine versucht das Ticket in die Datenbank einzutragen
  	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
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
 
 sub print_submit_assumeTicket {  #Mitarbeiter übernimmt angegebenes Ticket
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success1 = db_access::assume_Ticket($Username,$Ticket_ID);
 	my $success2 = db_access::answer_Ticket($Username,$Ticket_ID,"Ticket wurde zur Bearbeitung übernommen!");
 	if($success1 != 0 && $success2 != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich uebernommen!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht uebernommen werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
 
sub print_Statistik{
 	my $cgi = new CGI;
	my $session = CGI::Session->new($cgi);
	print $cgi->h1("Statistik");
	#print "Content-type: image/png\n\n";
 	#print myGraph::print_Statistik_TicketStatus();
 	
 	my $mygraph = myGraph::print_Statistik_TicketStatus();
 	print qq!<img src="/rocket/$mygraph" alt="Statistik_TicketStatus"></img>!;
 	
 }