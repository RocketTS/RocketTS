#!"C:\xampp\perl\bin\perl.exe" -w 

#Modul Login.pm soll folgende Fumktionen bereitstellen
#html_login -> Login-Seite ausgeben

package Login;

use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(html_login);


 sub html_login
 #Uebergabeparameter ist das CGI-Objekt, mit dem gearbeitet werden soll.
 {
 	my $cgi = CGI->new($_[0]);	#Uebernehme das alte CGI-Objekt und arbeite damit!
 	
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
	 						-action => "/cgi-bin/rocket/Login.cgi",
	 						-target => '_self'
	 						 });
	 
	 print $cgi->hidden(-name=>'Site',
	 				   -value=>'Login');
	 				   
	 print $cgi->strong("Benutzer\t");
	 
	 print $cgi->textfield(-name=>'Login',
	 					  -value=>'E-Mail Adresse',
	 					  -size=>25,
	 					  -maxlength=>50);
	 print $cgi->br();
	 
	 print $cgi->strong("Passwort\t");	
	 						
	 print $cgi->password_field(-name=>'Password',
	 						   -value=>'',
	 						   -size=>25,
	 						   -maxlength=>50);
	 print $cgi->br();
	 print $cgi->submit("Einloggen");
	 print $cgi->end_form();
	 print $cgi->end_div();
    $cgi->end_html();
  	1;
 }