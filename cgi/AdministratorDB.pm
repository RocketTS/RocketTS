#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 14.04.2013                    #
########################################
#Description: wird nur von AdministratorContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package AdministratorDB;

use db_access 'valid_Login','insert_User','exist_User','get_Messages_from_Ticket','get_newTickets','get_TicketsbyStatus';
use feature qw {switch};
use strict;
use Exporter;
use HTML::Table;

our @EXPORT_OK = qw();

