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
use UserContent 'print_Index', 'print_User_Testseite', 'show_Messages_from_Ticket';
use HTML::Table;
use myGraph 'print_Statistik_TicketStatus';


our @EXPORT_OK = qw(print_show_newTickets print_show_inprocessTickets print_show_History print_show_Statistik print_show_User 
					print_show_inprocessTickets print_show_History print_Statistik print_submit_assumeTicket 
					print_submit_forwardTicket print_submit_releaseTicket print_submit_closeTicket);


 
 sub print_show_newTickets
 {#Alle von neu erstellten Tickets werden anzeigt
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = MitarbeiterDB::get_allnewTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("‹bersicht der neu erstellten Tickets");

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
	
	print $cgi->h1("‹bersicht der Tickets in Bearbeitung");
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der L‰nge des Inhalts der Zelle gegeben
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
	
	print $cgi->h1("‹bersicht der Tickets in Bearbeitung");
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der L‰nge des Inhalts der Zelle gegeben
	$table->setClass("table_tickets");
	print $table->getTable();	
	
	
 }
 
 sub print_show_specTicket
{#Ein bestimmtes von dem User erstellten Tickets wird Verlaufsm‰ﬂig angezeigt
 #Dabei soll der User eine neue Message anh‰ngen/antworten kˆnnen
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
	#mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
	#User her
	my $session = CGI::Session->new($cgi);
	my $TicketID = $session->param('specificTicket');
	
	print $cgi->h1("Das Ticket mit der ID $TicketID wird nachfolgend im \"Verlaufsmodus\" angezeigt!");
	my $ref_table = show_Messages_from_Ticket($TicketID,$session->param('UserIdent'));
	my $table = $$ref_table;
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der L‰nge des Inhalts der Zelle gegeben
	$table->setClass("table_tickets");
	print $table->getTable();	
	print $cgi->br;
	
	#Ausgeben der Buttons nebeneinander dank simpler HTML-Tabelle
	print '<table>
	<tr>
	<td>';
	
	#Abfragen f¸r die Aktions-Buttons, um DB-Abfragen zu reduzieren
	my $TicketStatus = db_access::get_TicketStatus($TicketID);	
	my $TicketPrioritaet = db_access::get_TicketPrioritaet($TicketID);
	my $is_Authorized = db_access::is_Authorized($session->param('UserIdent'),$session->param('specificTicket'));
	
	#Anzeigen des ‹bernehmen-Buttons
	if(($TicketStatus eq "in Bearbeitung") || ($TicketStatus eq "Geschlossen")) {
		print "<input type=\"submit\" name=\"‹bernehmen\" value=\"‹bernehmen\" disabled>";
	}
	else {
		print $cgi->start_form({-method => "POST",
	 							-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 							-target => '_self'
	 						   });
		print $cgi->hidden(-name=>'Level2',
	 				       -value=>'submit_assumeTicket'); 				   
		print $cgi->submit("‹bernehmen");
	
		print $cgi->end_form();
	}
	
	print '</td>
	<td>';
	
	#Anzeigen des Weiterleiten-Buttons, wenn Prio >1 und der Bearbeitende User angemeldet ist
	if(($TicketPrioritaet == 1) || $is_Authorized == 0 || ($TicketStatus eq "Geschlossen")) {
		print "<input type=\"submit\" name=\"Weiterleiten\" value=\"Weiterleiten\" disabled>";
	}
	else {
		print $cgi->start_form({-method => "POST",
		 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
		 						-target => '_self'
		 						 });
		print $cgi->hidden(-name=>'Level2',
		 				   -value=>'submit_forwardTicket');
		print $cgi->submit("Weiterleiten");
		print $cgi->end_form();
	}
		print '</td>
	<td>';
	
	#Anzeigen des Freigeben-Buttons, wenn der aktuelle MA auch der Bearbeiter ist
	if($TicketStatus eq "Geschlossen" || $is_Authorized == 0) {
		print "<input type=\"submit\" name=\"Freigeben\" value=\"Freigeben\" disabled>";
	}
	else {
		print $cgi->start_form({-method => "POST",
		 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
		 						-target => '_self'
		 						 });
		print $cgi->hidden(-name=>'Level2',
		 				   -value=>'submit_releaseTicket');
		print $cgi->submit("Freigeben");
		print $cgi->end_form();
	}
		print '</td>
	<td>';
	#Anzeigen des Schlieﬂen-Buttons
	if($TicketStatus ne "in Bearbeitung" || $is_Authorized == 0) {
		print "<input type=\"submit\" name=\"Schliessen\" value=\"Schliessen\" disabled>";
	}
	else {
		print $cgi->start_form({-method => "POST",
		 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
		 						-target => '_self'
		 						 });
		print $cgi->hidden(-name=>'Level2',
		 				   -value=>'submit_closeTicket');
		print $cgi->submit("Schliessen");
		print $cgi->end_form();
	}
		print '</td>
	</tr>
	</table>';
	#Zeige das "Antwortformular", wenn Ticket in Bearbeitung + MA = Bearbeiter	
	if($TicketStatus eq "in Bearbeitung" && $is_Authorized == 1) {
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
 }
 
 
 sub print_submit_assumeTicket {  #Mitarbeiter ¸bernimmt angegebenes Ticket
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success1 = db_access::assume_Ticket($Username,$Ticket_ID);
 	#my $success2 = db_access::answer_Ticket($Username,$Ticket_ID,"Ticket wurde zur Bearbeitung ¸bernommen!");
 	#if($success1 != 0 && $success2 != 0)
 	if($success1 != 0)
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
 
  sub print_submit_forwardTicket {  #Mitarbeiter leitet angegebenes Ticket weiter
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success1 = db_access::forward_Ticket($Username,$Ticket_ID);
 	#my $success2 = db_access::answer_Ticket($Username,$Ticket_ID,"Ticket wurde zur n‰chsten Instanz weitergeleitet!");
 	#if($success1 != 0 && $success2 != 0)
 	if($success1 != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich weitergeleitet!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht weitergeleitet werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
 
  sub print_submit_releaseTicket {  #Mitarbeiter gibt angegebenes Ticket frei
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success1 = db_access::release_Ticket($Username,$Ticket_ID);
 	#my $success2 = db_access::answer_Ticket($Username,$Ticket_ID,"Ticket wurde wieder freigegeben!");
 	#if($success1 != 0 && $success2 != 0)
 	if($success1 != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich freigegeben!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht freigegeben werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
  
  sub print_submit_closeTicket {  #Mitarbeiter schlieﬂt angegebenes Ticket
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success1 = db_access::close_Ticket($Username,$Ticket_ID);
 	#my $success2 = db_access::answer_Ticket($Username,$Ticket_ID,"Ticket wurde geschlossen!");
 	#if($success1 != 0 && $success2 != 0)
 	if($success1 != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich geschlossen!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht geschlossen werden!");
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