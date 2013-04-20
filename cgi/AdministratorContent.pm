#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 02.04.2013                    #
########################################
#Description: Stellt Funktionen bereit um Inhalte von der Administratorr-Website darzustellen

package AdministratorContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Exporter;
use db_access 'create_Ticket','get_TicketStatus','get_TicketPrioritaet','is_Authorized';
use MitarbeiterDB;
use HTML::Table;



our @EXPORT_OK = qw();


sub print_UserList {
	#gibt die Benutzerliste aus
	
 	#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie mit der Session-ID
	my $cgi = new CGI;

	#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen User her
	my $session = CGI::Session->new($cgi);
	
	#Hole die HTML-Tabelle mit den Usern
	my $ref_table = AdministratorDB::get_UserList();
	my $table = $$ref_table;
	
	print $cgi->h1("Übersicht der Benutzer");
	$table->setAttr('style="table-layout:fixed"'); #Damit wird der ColWidth Vorrang vor der Länge des Inhalts der Zelle gegeben
	$table->setClass("table_tickets");
	print $table->getTable();	
 }
 
 sub print_show_specUser {
 	#wird ausgeführt, wenn Admin einen Benutzer zum bearbeiten ausgewählt hat
 	my $cgi = new CGI;
 	my $session = CGI::Session->new($cgi);
 	
 	
 	my ($User_ID,$Name,$Vorname,$Email) = AdministratorDB::get_UserDatabyID($session->param('specificUser'));
 	my $AccessRights = AdministratorContent::get_AccessRights($Email);
 	
 
	my %Rechte = ('0'=>'User', '1'=>'Mitarbeiter', '2'=>'Administrator'); #Kommentar
	my $ref_Rechte = \%Rechte;
	my %Level = ('1'=>'Level 1', '2'=>'Level 2', '3'=>'Level 3'); #Kommentar
	my $ref_Level = \%Level;


	print $cgi->h1("Ändern der Benutzerdaten");
	print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 					   });	 
	print $cgi->hidden(-name=>'Level2',-value=>'submit_changeUser'); 
	
	print "<table>";
	print "<tr>";
	print "<td>";				   
	print $cgi->strong("Name:\t");
	print "</td><td>";		 						
	print $cgi->textfield(-name=>'input_Name_new',
						  -value=>$Name,
	 					  -size=>25,
	 					  -maxlength=>50);
	print "</td></tr>";
	print "<tr>";
	print "<td>";
	#print $cgi->br();			
	 
	print $cgi->strong("Vorname:\t");	
	print "</td><td>";	 						
	print $cgi->textfield(-name=>'input_Vorname_new',
						  -value=>$Vorname,
	 					  -size=>25,
	 					  -maxlength=>50);
	print "</td></tr>";
	print "<tr>";
	print "<td>";	
	print $cgi->strong("Email:\t");	
	print "</td><td>";
	 						
	print $cgi->textfield(-name=>'input_Email_new',
						  -value=>$Email,
	 					  -size=>25,
	 					  -maxlength=>50);
	print "</td></tr>";
	print "<tr>";
	print "<td>";		
	print $cgi->strong("Rechte:\t");	
	print "</td><td>";
	if($AccessRights ne 'User'){
		delete $Rechte{'0'};
	}
		MitarbeiterContent::print_dropDown("input_AccessRights_new",$ref_Rechte,'Level 3');
	print "</td></tr>";
	if($AccessRights){
		my $ref_Abteilung = UserDB::get_DropDownValues("abteilung");
		print "<tr><td>";
		print $cgi->strong("Level:\t");
		print "</td><td>";
		MitarbeiterContent::print_dropDown("input_Level_new",$ref_Level,$AccessRights);
		print "</td></tr>";
		print "<tr><td>";
		print $cgi->strong("Abteilung:\t");
		print "</td><td>";
		UserContent::print_dropDown("input_Abteilung_new",$ref_Abteilung);
		print "</td></tr>";
	}
	print "<tr>";
	print "<td></td><td>"; 						
								 									 
	print $cgi->submit("Übernehmen");
	print "</td></tr>";
	print "</table>";

	print $cgi->end_form();	
 }
 
 sub print_dropDown
 {	#Dieses Modul soll einfach ein DropDown ausgeben
  	#
  	#Beispiel 0 => User
  	#		  1 => Mitarbeiter
  	#		  2 => Administrator
  	my ($name,$ref_Array,$AccessRights) = @_;
  	my %deref_Array = %$ref_Array;
  	
  	#Hier wird jetzt der HTML-Code ausgegeben
  	print "<select name=\"$name\">";
  	foreach my $key ( keys %deref_Array ) 
  	{
  		if($AccessRights eq $deref_Array{$key}){
  			print "<option selected='selected' value=\"$key\">$deref_Array{$key}";	
  		}
  		else {
  			print "<option value=\"$key\">$deref_Array{$key}";	
  		}
 	}
 	print "</select> ";
 }
 
 sub print_submit_changeUser {  #Administrator schließt angegebenes Ticket
	my $cgi = new CGI;
 	my($User_ID) = @_;
 	my $success = AdministratorDB::change_User($User_ID);
 	if($success != 0)
 	{
 		UserContent::print_User_Testseite("Benutzer wurde erfolgreich geändert!");
 	}
 	else
 	{
 		UserContent::print_User_Testseite("Fehler! Benutzer konnte nicht geändert werden!");
 	}
 	#Leite nach 3 Sekunden auf die spezifische Ticketansicht weiter (ueber die Root)
 	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/SaveFormData.cgi?Level2=show_User'});

 }

 1;
