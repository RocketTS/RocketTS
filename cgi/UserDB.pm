#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 30.03.2013                    #
########################################
#Description: wird nur von UserContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package UserDB;

use db_access 'valid_Login','insert_User','exist_User','get_Messages_from_Ticket';
use feature qw {switch};
use strict;
use Exporter;
use HTML::Table;

our @EXPORT_OK = qw(show_Tickets show_Messages_from_Ticket);

sub get_Tickets
{#1. Uebergabeparameter = UserIdent (Email)
 #Liefert eine HTML-Tabllen-Objekt zurueck
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_Tickets($UserIdent);
 #Hole das Ticketarray
 my @Ticketarray = @$ref_Ticketarray;
 	
 #Erstelle das TableObjekt
 my $table = HTML::Table->new( 
    	-cols    => 2, 
    	-border  => 0,
    	-padding => 1,
    	-width	 => '100%',
    	-align   => 'center',
    	-head => ['Erstelldatum', 'Betreff'],
 );
	
 foreach my $array ( @{$ref_Ticketarray} ) {
	 #Jetzt wird aus dem Topic ein Link generiert, 
	 #welcher verwendet wird um den Nachrichtenverlauf anzuzeigen
	 my $LinkText = $array->[2];
	 my $TicketID = $array->[0];
	 
	 my $Link = "<a href=\"/cgi-bin/rocket/SaveFormData.cgi?input_specificTicket=$TicketID&Level2=show_specTicket\">$LinkText</a>";
	  
	 #Das Erstelldatum und der veränderte "TopicLink" werden der HTML-Tabelle hinzugefügt
	 $table->addRow($array->[1], $Link);
 }

 $table->addRow('1', '2');
 $table->setColWidth(1, 200);		#Legt die Breite der ersten Spalte fest (100 Pixel)
 $table->setColAlign(1, 'left');	#Erste Spalte wird zentriert dargestellt
 $table->setColAlign(2, 'left');	#zweite Spalte wird zentriert dargestellt
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
	
}