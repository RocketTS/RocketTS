#!perl -w 

#Dies soll das Login-Frontend sein

use CGI::Session;
use feature qw {switch};
use strict; 
use CGI; 
use CGI::Cookie;
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Login 'html_login','html_registration','html_login_successfull','html_registration_successfull'; 
use db_Login 'login_User', 'regist_User';
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;
# new session object, will get session ID from the query object
# will restore any existing session with the session ID in the query object
#my $s = CGI::Session->new($cgi);

# print the HTTP header and set the session ID cookie
#print $s->header();


given ($cgi->param('input_Site')){
  when( undef )							 { Login->html_login(); } 
  
  when('Registration_init')	 			 { Login->html_registration(); }
  
  when('Registration_check')	 	 	{  	my $value = db_Login->regist_User($cgi->param('input_Vorname'),
  																			  $cgi->param('input_Nachname'),
  																			  $cgi->param('input_Email'),
  																			  $cgi->param('input_Passwort1'),
  																			  $cgi->param('input_Passwort2') 
  																			  );
  											$cgi->param('input_Site',$value);
  											#print $page->meta({-http_equiv => 'REFRESH', -content => '0;/cgi-bin/user.cgi'}); 
  										 }
  
  when('Registration_successfull')	 	 { Login->html_testseite("Die Registrierung war erfolgreich!"); }
  
  when('Registration_failed')	 	 	 { Login->html_testseite("Die Registrierung fehlgeschlagen!"); }
  
  when('Registration_user_exist_already'){ Login->html_testseite("Die Registrierung fehlgeschlagen! Den Benutzer gibt es bereits!"); }
  
  when('Registration_password_not_equal'){ Login->html_testseite("Die Registrierung fehlgeschlagen! Die 2 eingegebenen Passwörter sind nicht identisch!"); }
  
  when('Login_check')					 { if(($cgi->param('input_Login') ne 'E-Mail Adresse') && $cgi->param('input_Password') ne ""
  												&& $cgi->param('input_Site') eq "Login_check")						 #Ueberpruefe ob tatsächlich was eingegeben wurde
  									  			{Login->html_login_successfull();}								 #Ansonsten leite auf die Loginseite um
  											else
  												{Login->html_testseite("Login fehlgeschlagen!");}
  										 }
  										 
  when('Login_valid')					 { my $value = &db_Login->login_User($cgi->param('input_Email'),
  																			 $cgi->param('input_Passwort1')
  																			 );
  										   $cgi->param('input_Site',$value);
  										  }
  										 
  default								 { print $cgi->h1("Problem mit der Websitenauswahl") }
}


given ($cgi->param('input_Site')){
  
  when('Registration_successfull')	 	 { Login->html_testseite("Die Registrierung war erfolgreich!"); }
  
  when('Registration_failed')	 	 	 { Login->html_testseite("Die Registrierung fehlgeschlagen!"); }
  
  when('Registration_user_exist_already'){ Login->html_testseite("Die Registrierung fehlgeschlagen! Den Benutzer gibt es bereits!"); }
  
  when('Registration_password_not_equal'){ Login->html_testseite("Die Registrierung fehlgeschlagen! Die 2 eingegebenen Passwörter sind nicht identisch!"); }

}
