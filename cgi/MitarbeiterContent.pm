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


our @EXPORT_OK = qw(print_show_newTickets print_show_inprocessTickets print_show_History print_show_Statistik print_show_User print_show_inprocessTickets print_show_History print_Statistik);




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
 
sub print_Statistik{
 	my $cgi = new CGI;
	my $session = CGI::Session->new($cgi);
	print $cgi->h1("Statistik");
	#print "Content-type: image/png\n\n";
 	#print myGraph::print_Statistik_TicketStatus();
 	
 	my $mygraph = myGraph::print_Statistik_TicketStatus();
 	print qq!<img src="/rocket/$mygraph" alt="Statistik_TicketStatus"></img>!;
 	
 }