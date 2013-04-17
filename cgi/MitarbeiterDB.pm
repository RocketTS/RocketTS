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

sub get_UserList {
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_User();
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray; #überflüssig?
 #print $ref_Ticketarray;
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 6, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['User_ID','Name','Vorname','Email','Rechte','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($User_ID,$Name,$Vorname, $Email) = @$array;
	 my $Rechte = db_access::get_AccessRights($Email); #Überarbeiten da zu viele DB-Abfragen
	 my $Aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificUser=$User_ID&Level2=show_specUser\" target=\"_self\">bearbeiten</a>";
	  
	 $table->addRow($User_ID,$Name,$Vorname, $Email, $Rechte, $Aktion);
 }

 return \$table;
}