#!"C:\xampp\perl\bin\perl.exe" -w 

#Dies soll das Login-Frontend sein

use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
 
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;


 #-----------------------------------------
 #Funktionen für Darstellung
 #-----------------------------------------
 #Rückgabeparameter (???) muss noch geklärt werden
 sub Login
 {
 	
 	
 	print $cgi->header(-type    =>'text/html',
                   			-expires =>'+1s'
                   			),
                   			
 	$cgi->start_html(-title  =>'Ticketsystem Team Rocket!',
            			-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Login.css'}
                       ),

    $cgi->h1('  ');
     #Ausgabe des Headers
	 print "<center><div class = 'header'>";
	 print "<h1>Ticketsystem</h1>";
	 print "</div>";
	
	 #Ausgabe des Einlog-Formulares
	 print "<div class = 'body'>";
	 print "<h2>Login: </h2>";
	 
	 print$cgi->start_form();
	 
	 print$cgi->hidden(-name=>'Site',
	 				   -value=>'Login');
	 				   
	 print$cgi->strong("Benutzer\t");
	 
	 print$cgi->textfield(-name=>'Login',
	 					  -value=>'E-Mail Adresse',
	 					  -size=>25,
	 					  -maxlength=>50);
	 print("<br>");
	 
	 print$cgi->strong("Passwort\t");	
	 						
	 print$cgi->password_field(-name=>'Password',
	 						   -value=>'',
	 						   -size=>25,
	 						   -maxlength=>50);
	 print("<br>");
	 print$cgi->submit("Button");
	 print$cgi->end_form();
	 print"</div></center>";
    $cgi->end_html();
 }
 


if(!($cgi->param('Login') && ($cgi->param('Login') ne 'E-Mail Adresse') && $cgi->param('Password')))
{#Solange keine Email-Adresse und kein Passwort eingegeben wurde, leite auf Login-Seite
	&Login();
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


