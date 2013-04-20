#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 14.04.2013                    #
########################################
#Description: wird nur von AdministratorContent.pm aufgerufen
#Stellt Funktionen bereit die auf access_db zugreifen
#um Informationen aus der Datenbank zu holen/einzutragen


package AdministratorDB;

use feature qw {switch};
use strict;
use HTML::Table;
use CGI;
use CGI::Session;
use db_access;

sub change_User {
	#Auswahl  0 => User
  	#		  1 => Mitarbeiter
  	#		  2 => Administrator
	my $cgi = new CGI;
 	my $session = CGI::Session->new($cgi);
	my($User_ID) = @_;
	my @Rechte = ('User','Mitarbeiter','Administrator');
	
	my $AccessRights_Alt = db_access::get_AccessRights(db_access::get_Email($User_ID));
	my $AccessRights_Neu = $session->param('AccessRights_new');
	my $Name_Neu = $session->param('Name_new');
	my $Vorname_Neu = $session->param('Vorname_new');
	my $Email_Neu = $session->param('Email_new');
	my $Level_Neu = $session->param('Level_new');
	my $Abteilung_Neu = $session->param('Abteilung_new');
	my $Email = db_access::get_Email();
	my $return = 0;

	if($AccessRights_Alt eq $Rechte[$AccessRights_Neu]) { #Wenn keine Änderung der Rechte erfolgt ist
		$return = db_access::update_User($User_ID,$Name_Neu,$Vorname_Neu, $Email_Neu);
	}
	else {
		db_access::update_User($User_ID,$Name_Neu,$Vorname_Neu, $Email_Neu);
		$return = db_access::update_AccessRights($User_ID,$AccessRights_Alt,$Rechte[$AccessRights_Neu],$Abteilung_Neu,$Level_Neu);
	}
	return $return;
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

sub get_UserDatabyID {
	#Aufruf: get_UserData($User_ID);
	#liefert Benutzerdaten zu der übergebenen User_ID
	my($User_ID) = @_;
	my @array = db_access::get_UserData($User_ID);
	return @array;
}

sub get_AccessRights {
	my($Email) = @_;
	my $AccessRights = db_access::get_AccessRights($Email);
	return $AccessRights;
}

1;
