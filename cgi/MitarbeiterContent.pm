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
use HTML::Table;




 
 sub print_show_newTickets {
 	#gibt die neuen Tickets des Mitarbeiters aus
 	
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets und dereferenziert
	my $ref_table = MitarbeiterDB::get_allnewTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("‹bersicht der neu erstellten Tickets");

	$table->setClass("table_tickets");
	print $table->getTable();	
	
	
 }
  sub print_show_inprocessTickets {
  	#gibt die Tickets aus, die vom jeweiligen Mitarbeiter momentan bearbeitet werden
 
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
 
   sub print_show_History {
   	#gibt die Tickets aus, die vom Mitarbeiter bearbeitet wurden 
 
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Tickets
	my $ref_table = MitarbeiterDB::get_allclosedTickets($session->param('UserIdent'));
	my $table = $$ref_table;
	
	print $cgi->h1("‹bersicht der von dir geschlossenen Tickets");
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der L‰nge des Inhalts der Zelle gegeben
	$table->setClass("table_tickets");
	print $table->getTable();	
	
	
 }
 
 sub print_show_specTicket {
 	#gibt die Informationen des ausgew‰hlten Tickets aus, sowie Bearbeitungsoptionen und der Antwortmˆglichkeit f¸r den Mitarbeiter
 	
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen User her
	my $session = CGI::Session->new($cgi);
	my $TicketID = $session->param('specificTicket');
	
	print $cgi->h1("Das Ticket mit der ID $TicketID wird nachfolgend im \"Verlaufsmodus\" angezeigt!");
	
	#Abrufen aller Nachrichten zum ausgew‰hlten Ticket und Ausgabe in Tabelle
	my $ref_table = UserDB::show_Messages_from_Ticket($TicketID,$session->param('UserIdent'));
	my $table = $$ref_table;
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der L‰nge des Inhalts der Zelle gegeben
	$table->setClass("table_tickets");
	print $table->getTable();	
	print $cgi->br;
	
	#Ausgeben der Buttons nebeneinander dank simpler HTML-Tabelle
	print '<table>
	<tr>
	<td>';
	
	#DB-Abfragen f¸r die Aktions-Buttons, um DB-Abfragen zu reduzieren
	my ($TicketStatus,$TicketPrioritaet,$is_Authorized) = MitarbeiterDB::show_specTicketData($TicketID,$session->param('UserIdent'));
	
	#Anzeigen des ‹bernehmen-Buttons, wenn Ticket nicht in Bearbeitung oder nicht geschlossen ist
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
 
 
 sub print_submit_assumeTicket {  
 	#wird ausgef¸hrt, wenn Mitarbeiter das angegebenes Ticket ¸bernimmt
 	#‹bergabewerte (Email, TicketID)
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success = MitarbeiterDB::assume_Ticket($Username,$Ticket_ID);
 	if($success != 0)
 	{
 		UserContent::print_User_Testseite("Ticket wurde erfolgreich uebernommen!");
 	}
 	else
 	{
 		UserContent::print_User_Testseite("Fehler! Ticket konnte nicht uebernommen werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
 
  sub print_submit_forwardTicket {  
  	#wird ausgef¸hrt, wenn Mitarbeiter das angegebenes Ticket weiterleitet
 	#‹bergabewerte (Email, TicketID)
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success = MitarbeiterDB::forward_Ticket($Username,$Ticket_ID);

 	if($success != 0)
 	{
 		UserContent::print_User_Testseite("Ticket wurde erfolgreich weitergeleitet!");
 	}
 	else
 	{
 		UserContent::print_User_Testseite("Fehler! Ticket konnte nicht weitergeleitet werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
 
  sub print_submit_releaseTicket { 
  	#wird ausgef¸hrt, wenn Mitarbeiter das angegebenes Ticket wieder freigibt
 	#‹bergabewerte (Email, TicketID)
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success = MitarbeiterDB::release_Ticket($Username,$Ticket_ID);
 	
 	if($success != 0)
 	{
 		UserContent::print_User_Testseite("Ticket wurde erfolgreich freigegeben!");
 	}
 	else
 	{
 		UserContent::print_User_Testseite("Fehler! Ticket konnte nicht freigegeben werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
  
  sub print_submit_closeTicket { 
  	#wird ausgef¸hrt, wenn Mitarbeiter das angegebenes Ticket schlieﬂt
 	#‹bergabewerte (Email, TicketID)
	my $cgi = new CGI;
 	my($Username,$Ticket_ID) = @_;
 	my $success = MitarbeiterDB::close_Ticket($Username,$Ticket_ID);

 	if($success != 0)
 	{
 		UserContent::print_User_Testseite("Ticket wurde erfolgreich geschlossen!");
 	}
 	else
 	{
 		UserContent::print_User_Testseite("Fehler! Ticket konnte nicht geschlossen werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_specTicket'});

 }
 
sub print_Statistik{
	#gibt die Graphen der Statistik aus
 	my $cgi = new CGI;
	my $session = CGI::Session->new($cgi);
	
	#l‰sst Graphen erstellen, abspeichern und gibt diesen aus
 	my $mygraph = myGraph::print_Statistik_TicketStatus();
 	
 	print $cgi->h1("Statistik");
 	print qq!<img src="/rocket/$mygraph" alt="Statistik_TicketStatus"></img>!;
 }
1;
