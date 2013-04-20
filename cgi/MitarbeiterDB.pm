#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 02.04.2013                    #
########################################
#Description: wird nur von MitarbeiterContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package MitarbeiterDB;

use db_access 'valid_Login','insert_User','exist_User','get_Messages_from_Ticket','get_newTickets','get_TicketsbyStatus';
use feature qw {switch};
use strict;
use Exporter;
use HTML::Table;

our @EXPORT_OK = qw(show_Tickets get_allnewTickets get_allinprocessTickets get_allclosedTickets);

sub get_allnewTickets {
 #Liefert ein HTML-Tabellen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_TicketsbyStatus($UserIdent,'Neu');
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray; #überflüssig?
 #print $ref_Ticketarray;
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 9, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['Ticket_ID','Ersteller','Erstelldatum','Betreff','Auswahlkriterien','Priorität','IP','OS','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Ersteller,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	  
	 $table->addRow($ticket_ID,$Ersteller,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$aktion);
 }

 return \$table;
}

sub get_allinprocessTickets {
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_TicketsbyStatus($UserIdent,'in Bearbeitung');
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray; #überflüssig?
 #print $ref_Ticketarray;
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 9, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['Ticket_ID','Erstelldatum','Betreff','Auswahlkriterien','Priorität','IP','OS','Status','Bearbeiter','Aktionen'],
 );

my $Ak = db_access::get_Auswahlkriterien($UserIdent);	

 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$Status,$Bearbeiter) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	 if($Auswahlkriterien == $Ak) {  
	 	$table->addRow($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$Status,$Bearbeiter,$aktion);
	 }
}

 return \$table;
}

sub get_allclosedTickets {
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_TicketsbyStatus($UserIdent,'Geschlossen');
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray; #überflüssig?
 #print $ref_Ticketarray;
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 9, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['Ticket_ID','Erstelldatum','Betreff','Auswahlkriterien','Priorität','IP','OS','Status','Bearbeiter','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$Status,$Bearbeiter) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	  
	 $table->addRow($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$Status,$Bearbeiter,$aktion);
 }

 return \$table;
}






sub show_specTicketData {
	#führt DB-Abfragen für die Aktions-Buttons aus, um DB-Abfragen zu reduzieren
	#Schnittstelle
	#Übergabeparameter (TicketID, Email)
	#Rückgabewerte
	my ($TicketID,$User) = @_;
	my $TicketStatus = get_TicketStatus($TicketID);	
	my $TicketPrioritaet = db_access::get_TicketPrioritaet($TicketID);
	my $is_Authorized = db_access::is_Authorized($User,$TicketID);
	return ($TicketStatus,$TicketPrioritaet,$is_Authorized);
}

sub assume_Ticket {
	#Aufruf assume_Ticket($Username,$Ticket_ID);
	my ($Username,$Ticket_ID) = @_;
	my $success = db_access::assume_Ticket($Username,$Ticket_ID);
	return $success;
}
sub forward_Ticket {
	#Aufruf assume_Ticket($Username,$Ticket_ID);
	my ($Username,$Ticket_ID) = @_;
	my $success = db_access::forward_Ticket($Username,$Ticket_ID);
	return $success;
}
sub release_Ticket {
	#Aufruf assume_Ticket($Username,$Ticket_ID);
	my ($Username,$Ticket_ID) = @_;
	my $success = db_access::release_Ticket($Username,$Ticket_ID);
	return $success;
}
sub close_Ticket {
	#Aufruf assume_Ticket($Username,$Ticket_ID);
	my ($Username,$Ticket_ID) = @_;
	my $success = db_access::close_Ticket($Username,$Ticket_ID);
	return $success;
}
1;