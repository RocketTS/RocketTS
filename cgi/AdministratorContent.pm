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
use db_access 'create_Ticket','get_TicketStatus','get_TicketPrioritaet','is_Authorized';
use MitarbeiterDB 'get_allnewTickets','get_allinprocessTickets','get_allclosedTickets';
use HTML::Table;
use myGraph 'print_Statistik_TicketStatus';


our @EXPORT_OK = qw(print_show_newTickets print_show_inprocessTickets print_show_History print_show_Statistik print_show_User 
					print_show_inprocessTickets print_show_History print_Statistik print_answerTicket print_submit_assumeTicket 
					print_submit_forwardTicket print_submit_releaseTicket print_submit_closeTicket);




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
    print $cgi->h1( $cgi->center("Startseite von " . $session->param('UserIdent') ." Rechte: ".$session->param('AccessRights')));
	1;  
}
 
