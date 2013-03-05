#!"C:\xampp\perl\bin\perl.exe" -w 

#Dies soll das Login-Frontend sein


use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Login 'html_login'; 
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;



 
 sub Registration
 { 	
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
 		
 }


if(!($cgi->param('Login') && ($cgi->param('Login') ne 'E-Mail Adresse') && $cgi->param('Password')))
{#Solange keine Email-Adresse und kein Passwort eingegeben wurde, leite auf Login-Seite
	Login->html_login(\$cgi);
}
else
{#Parameter wurden eingelesen, jetzt müsste der Benutzer überprüft werden
	print $cgi->header(-type=>'text/html',
                   	   -expires =>'+1s'),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket!',
            		 -author =>'beispiel@example.org',
                     -base   =>'true',
                     -target =>'_blank',
                     -meta   =>{'keywords'   =>'TeamOne, Test',
                                'description'=>'Loginseite'},
                     -style  =>{'src'=>'../../css/Login.css'}
                      ),

    $cgi->h1('Parameter wurden eingegeben');
    $cgi->end_html();
}


