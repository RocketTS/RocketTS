#!perl -w 

#Modul Login.pm soll folgende Fumktionen bereitstellen
#html_login -> Login-Seite ausgeben
#html_registration ->Registration-Seite ausgeben

package Login;

use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(html_login html_registration html_login_successfull html_registration_successfull html_testseite);


 sub html_login
 {
 	my $cgi = CGI->new();
 	
 	print $cgi->header(-type    =>'text/html',
                   		-expires =>'+1s'
                   		),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket! Login',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Einlog-Formulares
	 print $cgi->start_div({-id=>'body'});
	 
	 print $cgi->h2("Login:");
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/Rocket.cgi",
	 						-target => '_self'
	 						 });
	 
	 print $cgi->hidden(-name=>'input_Site',
	 				   -value=>'Login_check');
	 				   
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
	 						-action => "/cgi-bin/rocket/Rocket.cgi",
	 						-target => '_self'
	 						 });
	 print $cgi->hidden(-name=>'input_Site',
	 				   -value=>'Registration_init');
	 print $cgi->submit("Registrieren");
	 
	 print $cgi->end_div();

    $cgi->end_html();
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
 		if($Value =~"Passwort")
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
 
 
 sub html_registration
 {
 	my $cgi = CGI->new();
 	print $cgi->header(-type    =>'text/html',
                   		-expires =>'+1s'
                   		),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket! Registration',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Registrations-Formulares
	 print $cgi->start_div({-id=>'body'});
	 
	 print $cgi->h2("Registration:");
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/Rocket.cgi",
	 						-target => '_self'
	 						 });
	 
	 print $cgi->hidden(-name=>'input_Site',
	 				   -value=>'Registration_check',
	 				   -override=>'Registration_check');
	 				   
	&print_register_textfields("Vorname", "input_Vorname",
								"Nachname", "input_Nachname",
								"Email", "input_Email",
								"Passwort", "input_Passwort1",
								"Passwort wiederholen", "input_Passwort2");
	
	
	 print $cgi->submit("Registrieren");
	 print $cgi->end_form();
	 print $cgi->end_div();
    $cgi->end_html();
  	1;
 }
 
 
 sub html_registration_successfull
 {
 	my $cgi = CGI->new();
 	print $cgi->header(-type    =>'text/html',
                   		-expires =>'+1s'
                   		),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket! Registration',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Bodys
	 print $cgi->start_div({-id=>'body'});
	 
	 print $cgi->h2("Registrierung war erfolgreich!!!:");
	 
	 
	 print $cgi->end_div();
    $cgi->end_html();
  	1;	
 }
 
 sub html_login_successfull
 {
 	my $cgi = CGI->new();
 	print $cgi->header(-type    =>'text/html',
                   		-expires =>'+1s'
                   		),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket! Registration',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Bodys
	 print $cgi->start_div({-id=>'body'});
	 
	 print $cgi->h2("Login war erfolgreich!!!:");
	 
	 
	 print $cgi->end_div();
    $cgi->end_html();
  	1;	
 }
 
 sub html_testseite
 {#Uebergabeparameter: Der Text, der als Ueberschrift ausgegeben werden soll
 	my $cgi = CGI->new();	
 	my $text = $_[0];
 	print $cgi->header(-type    =>'text/html',
                   		-expires =>'+1s'
                   		),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket! Registration',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       );

     #Ausgabe des Headers
     print $cgi->start_div({-id=>'header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Bodys
	 print $cgi->start_div({-id=>'body'});
	 
	 print $cgi->h2($text);
	 
	 
	 print $cgi->end_div();
    $cgi->end_html();
  	1;	
 }