#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 02.04.2013                    #
########################################
#Description: Stellt Funktionen bereit um Inhalte von der Mitarbeiter-Website darzustellen

package AdministratorContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Exporter;
use db_access 'create_Ticket','get_TicketStatus','get_TicketPrioritaet','is_Authorized';
use MitarbeiterDB;
use AdministratorDB;
use HTML::Table;



our @EXPORT_OK = qw();




 
