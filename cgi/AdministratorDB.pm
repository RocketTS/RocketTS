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

our @EXPORT_OK = qw(show_Tickets show_Messages_from_Ticket get_allnewTickets get_allinprocessTickets get_allclosedTickets);

sub get_allnewTickets {
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_newTickets();
 #my $ref_Ticketarray = db_access::get_TicketsbyStatus($UserIdent,"Neu"); #NEU + RICHTIGE ABFRAGE !!!
 
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
    	-head => ['Ticket_ID', 'Ersteller','Erstelldatum','Betreff','Auswahlkriterien','Priorität','IP','Betriebssystem','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Ersteller,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	  
	 $table->addRow($ticket_ID,$Ersteller,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$IP,$OS,$aktion);
 }

 #$table->addRow('1', '2');
 #$table->setColWidth(1, 200);		#Legt die Breite der ersten Spalte fest (100 Pixel)
 #$table->setColAlign(1, 'left');	#Erste Spalte wird zentriert dargestellt
 #$table->setColAlign(2, 'left');	#zweite Spalte wird zentriert dargestellt
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
    	-head => ['Ticket_ID','Erstelldatum','Betreff','Auswahlkriterien','Priorität','Status','Bearbeiter','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$Status,$Bearbeiter) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	  
	 $table->addRow($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$Status,$Bearbeiter,$aktion);
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
    	-head => ['Ticket_ID','Erstelldatum','Betreff','Auswahlkriterien','Priorität','Status','Bearbeiter','Aktionen'],
 );
	
 foreach my $array ( @$ref_Ticketarray ) {
	 #Jetzt wird aus dem Topic ein Link generiert, welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$Status,$Bearbeiter) = @$array;
	 my $aktion = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$ticket_ID&Level2=show_specTicket\" target=\"_self\">anzeigen</a>";
	  
	 $table->addRow($ticket_ID,$Erstelldatum,$Betreff,$Auswahlkriterien,$Prio,$Status,$Bearbeiter,$aktion);
 }

 return \$table;
}


sub show_Messages_from_Ticket{
	#1. Uebergabeparameter = TicketID
	#2. Uebergabeparameter = UserIdent
	#Zur Sicherheit wird zuerst geprueft ob der User sein eignes Ticket anschauen moechte
	#Danach werden alle Messages geholt diese in eine HTML-Tabelle verpackt und eine 
	#Referenz auf diese zurueckgegeben
	my $TicketID = $_[0];
	my $UserIdent = $_[1];
	
	my $ref_Messagearray = db_access::get_Messages_from_Ticket($UserIdent, $TicketID);
	my @Messagearray = @$ref_Messagearray;
	
	 #Erstelle das TableObjekt
	 my $table = HTML::Table->new( 
    	-cols    => 3, 
    	-border  => 0,
    #	-padding => 1,
   # 	-width	 => 970,
    	-align   => 'left',
    	-head => ['Erstelldatum', 'Benutzer', 'Nachricht'],
	 );

	 
	 foreach my $array ( @{$ref_Messagearray} ) {

	 my $Erstelldatum = $array->[1];
	 my $Author = $array->[0];
	 my $Message = $array->[2];
	 	  
	 #Das Erstelldatum und der veränderte "TopicLink" werden der HTML-Tabelle hinzugefügt
	 $table->addRow($Erstelldatum, $Author, $Message);
 	 }
 $table->setColWidth(1, 150);	#Legt die Breite der ersten Spalte fest (100 Pixel)
 $table->setColWidth(2, 200);	#Breite 2. Spalte
 $table->setColWidth(3, 550);	#Breite 3. Spalte

 return \$table;	
}