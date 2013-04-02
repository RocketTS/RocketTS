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
use MitarbeiterDB 'get_allnewTickets';
use HTML::Table;

our @EXPORT_OK = qw(print_show_newTickets print_show_inprocessTickets print_show_History print_show_Statistik print_show_User);




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
 }