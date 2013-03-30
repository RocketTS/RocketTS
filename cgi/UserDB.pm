#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 30.03.2013                    #
########################################
#Description: wird nur von UserContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package UserDB;

use db_access 'valid_Login','insert_User','exist_User';
use feature qw {switch};
use strict;
use Exporter;

our @EXPORT_OK = qw(get_Tickets);

sub get_Tickets
{#1. Uebergabeparameter = UserIdent (Email)
 #Liefert ein anonymes Array(Matrix) zurueck welche folgenden Aufbau hat
 #[Ticket_ID][Betreff]
 my $UserIdent = $_[0];
 
 my $ref_Ticketarray = db_access::get_Tickets($UserIdent);
 
 return $ref_Ticketarray;
}