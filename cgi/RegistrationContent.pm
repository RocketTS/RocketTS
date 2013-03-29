#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Stellt Funktionen bereit
#um Inhalte von der Registration-Website darzu
#stellen

package RegistrationContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Exporter;

our @EXPORT_OK = qw(printIndex);

sub printIndex
{
	my $cgi = CGI->new();
                  			
 	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Registration',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Style.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'login_header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Registrations-Formulares
	 print $cgi->start_div({-id=>'login_body'});
	 
	 print $cgi->h2("Registration:");
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	 
	 print $cgi->hidden(-name=>'Level1',
	 				   -value=>'Registration',
	 				   -override=>'Registration');
	 				   
	 print $cgi->hidden(-name=>'Level2',
	 				   -value=>'Check',
	 				   -override=>'Check');
	 				   
	&print_register_textfields("Vorname", "input_Vorname",
								"Nachname", "input_Nachname",
								"Email", "input_Email",
								"Passwort", "input_Password1",
								"Passwort wiederholen", "input_Password2");
	
	
	 print $cgi->submit("Registrieren");
	 print $cgi->end_form();
	 print $cgi->end_div();
    print $cgi->end_html();
  	1;
}


sub print_register_textfields
 #Uebergabeparameter ist ein (eindimensionales) Array mit folgendem Aufbau
 #Ausgabetext1, Textfeldname1,  
 #Ausgabetext2, Textfeldname2,
 #Hashmap geht nicht, weil die Reihenfolge der Elemente nicht garantiert statisch ist
 {
 	my $cgi = CGI->new();
 	my $AnzahlElemente = @_;
 	my $Value;
 	for(my $i = 0; $i<$AnzahlElemente ; $i++)
 	{
 		$Value = $_[$i];
	 	print $cgi->strong("$Value");	
 		#Zeige auf das zugehoerigen Namen fuers Textfeld
 		$i++;
 		$Value = $_[$i];
 		if($Value =~"Password")
 		{#Unterscheidung zwischen einem Text und Passwortfeld						
			print $cgi->password_field(-name=>"$Value",
			 						   -value=>'',
			 						   -size=>25,
			 						   -maxlength=>50);
 		}
 		else
 		{
 			print $cgi->textfield(-name=>"$Value",
			 					  -value=>'',
			 					  -size=>25,
								  -maxlength=>50);
 		}
		print $cgi->br();
 	}
 	1;
 }