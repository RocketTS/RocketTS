#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Stellt Funktionen bereit
#um Inhalte von der Login-Website darzu
#stellen

package LoginContent;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub printIndex
{	
	my $cgi = CGI->new();
 	my $session = CGI::Session->new($cgi);               			
 	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Login',
 							-author =>'beispiel@example.org',
                       		-base   =>'true',
               		        -target =>'_blank',
                   		    -meta   =>{'keywords'   =>'TeamOne, Test',
                        	          'description'=>'Loginseite'},
                       		-style  =>{'src'=>'../../css/Style.css'}
                      		);

     #Ausgabe des HTML-Headers
     print $cgi->start_div({-id=>'login_header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Einlog-Formulares
	 print $cgi->start_div({-id=>'login_body'});
	 
	 print $cgi->h2("Login:");
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	 
	 print $cgi->hidden(-name=>'Level1',
	 				   -value=>'Login');
	 
	 print $cgi->hidden(-name=>'Level2',
	 				   -value=>'Check');
	 				   
	 print $cgi->strong("Benutzer\t");
	 
	 print $cgi->textfield(-name=>'input_Login',
	 					  -value=>'E-Mail Adresse',
	 					  -size=>25,
	 					  -maxlength=>50);
	 print $cgi->br();
	 
	 print $cgi->strong("Passwort\t");	
	 						
	 print $cgi->password_field(-name=>'input_Password',
	 						   -value=>'',
	 						   -size=>25,
	 						   -maxlength=>50);
	 print $cgi->br();
	 print $cgi->submit("Einloggen");
	 print $cgi->end_form();
	 
	 #2. Form fuer den Registrierungsbutton
	 #Nur fuer Testzwecke, Todo: Nachschauen wie man einen einzelnen Button mit einer Funktion belegen kann
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/SaveFormData.cgi",
	 						-target => '_self'
	 						 });
	 print $cgi->hidden(-name=>'Level1',
	 				   -value=>'Registration');
	 				   
	 print $cgi->submit("Registrieren");
	 
	 print $cgi->end_div();

    print $cgi->end_html();
  	
 }
1;