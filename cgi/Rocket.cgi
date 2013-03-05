#!"C:\xampp\perl\bin\perl.exe" -w 

#Dies soll das Login-Frontend sein

use feature qw {switch};
use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Login 'html_login','html_registration','html_login_successfull','html_registration_successfull'; 
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;
#my $Switch_Temp = $cgi->param('Site');


if(!$cgi->param())
{
	Login->html_login(\$cgi);
}
#if($cgi->param('Site') eq "Login")
#{
#	Login->html_registration();
#}
else
{
	given ($cgi->param('Site')){
	  when("")								 { Login->html_login(\$cgi); } ##FUNKTIONIERT NICHT VERDAMMTE SCHEISSE
	  
	  when('Registration_initialisieren')	 { Login->html_registration(\$cgi); }
	  
	  when('Registration_abgeschlossen')	 { Login->html_registration_successfull(\$cgi); }
	  
	  when('Login')							 { if(($cgi->param('Login') ne 'E-Mail Adresse') && $cgi->param('Password') ne ""
	  												&& $cgi->param('Site') eq "Login")								 #Ueberpruefe ob tatsächlich was eingegeben wurde
	  									  		{Login->html_login_successfull(\$cgi);}								 #Ansonsten leite auf die Loginseite um
	  											else
	  											{Login->html_login(\$cgi);}
	  										 }
	  										 
	  default								 { print $cgi->h1("Problem mit der Websitenauswahl") }
	}
}

#Login->html_registration();

