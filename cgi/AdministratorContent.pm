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
use CGI::Session;
use HTML::Table;
use DebugUtils;
use UserContent;
use MitarbeiterContent;
use UserDB;
use MitarbeiterDB;
use AdministratorDB;



sub print_UserList {
	#Aufruf: print_UserList()
	#Ruft AdministratorDB::get_UserList() auf und gibt deren Benutzerliste aus
	#Ausgabe der Liste auf der Webseite
	
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
 	#Aufruf: print_show_specUser()
 	#wird ausgeführt, wenn Admin einen Benutzer zum bearbeiten ausgewählt hat
 	#Rückgabe: Gibt UserDaten auf der Webseite aus
 	
 	my $cgi = new CGI;
 	my $session = CGI::Session->new($cgi);
 	
 	#Holen der Userdaten anhand seiner User-ID / AccessRights anhand der DB
 	my ($User_ID,$Name,$Vorname,$Email) = AdministratorDB::get_UserDatabyID($session->param('specificUser'));
 	my $AccessRights = AdministratorDB::get_AccessRights($Email);
 	
 
	my %Rechte = ('0'=>'User', '1'=>'Mitarbeiter', '2'=>'Administrator'); #Hash für das Dropdown der Rechte
	my $ref_Rechte = \%Rechte;
	my %Level = ('1'=>'Level 1', '2'=>'Level 2', '3'=>'Level 3'); #Hash für das Dropdown der Level
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
		#Wenn $AccessRights ungleich User, wird der User-Eintrag aus dem Rechte-Hash entfernt, da kein Admin/MA zu einem User werden soll
		delete $Rechte{'0'};
	}
	print_dropDown("input_AccessRights_new",$ref_Rechte,'Level 3'); #Ausgabe des Level-Dropdowns
	print "</td></tr>";
	if($AccessRights){
		my $ref_Abteilung = UserDB::get_DropDownValues("abteilung"); #Abrufen der Dropdown-Werte für Abteilung
		print "<tr><td>";
		print $cgi->strong("Level:\t");
		print "</td><td>";
		print_dropDown("input_Level_new",$ref_Level,$AccessRights); #Ausgabe des AccessRights-Dropdowns
		print "</td></tr>";
		print "<tr><td>";
		print $cgi->strong("Abteilung:\t");
		print "</td><td>";
		UserContent::print_dropDown("input_Abteilung_new",$ref_Abteilung); #Ausgabe des Abteilungs-Dropdowns
		print "</td></tr>";
	}
	print "<tr>";
	print "<td></td><td>"; 						
								 									 
	print $cgi->submit("Übernehmen");
	print "</td></tr>";
	print "</table>";

	print $cgi->end_form();	
 }
 
 sub print_dropDown{	
 	#Aufruf: print_dropDown( Name der Variablenname für Identifizierung per Session, Daten-Array, Default-Wert )
 	#Dieses Modul soll einfach ein DropDown ausgeben
 	#Rückgabe: Ausgabe des Dropdown auf der Webseite

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
 
 sub print_submit_changeUser {  
 	#Aufruf: print_submit_changeUser( User_ID )
 	#Anzeige / Aufruf beim Ändern der Benutzerdaten
 	#Rückgabe: Ausgabe der Statusmeldung auf der Webseite
 	
	my $cgi = new CGI;
 	my($User_ID) = @_;
 	my $success = AdministratorDB::change_User($User_ID); #boolscher Rückgabewert, ob Änderung erfolgreich war
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
