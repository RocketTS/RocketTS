#!perl -w 

#Dies soll das Login-Frontend sein

use CGI::Session;
use feature qw {switch};
use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Login 'html_login','html_registration','html_login_successfull','html_registration_successfull'; 
use db_Login 'login_User', 'regist_User';
use db_access 'set_Hash';
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $Parameter;
my $cgi = new CGI;
# new session object, will get session ID from the query object
# will restore any existing session with the session ID in the query object
my $session = CGI::Session->new($cgi);

# print the HTTP header and set the session ID cookie
print $session->header();

given ($session->param('input_Site')){
  when( undef )							 { Login::html_login(); } 
  
  when('Registration_init')	 			 { Login::html_registration(); }
  
  when('Registration_check')	 	 	{  	$Parameter = db_Login::regist_User($session->param('input_Vorname'),
  																			  $session->param('input_Nachname'),
  																			  $session->param('input_Email'),
  																			  $session->param('input_Passwort1'),
  																			  $session->param('input_Passwort2') 
  																			  );
  											#Jetzt wird der Status (Parameter) mit einem Hidden-Feld setSession uebergeben und danach ausgewertet
  											$session->param('input_Site', $Parameter);
  											$session->clear('input_Vorname','input_Nachname','input_Email','input_Passwort1','input_Passwort2');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'});

  										 }
  
  when('Registration_successfull')	 	 { Login::html_testseite("Die Registrierung war erfolgreich!");
  											$session->clear('input_Site');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_failed')	 	 	 { Login::html_testseite("Die Registrierung fehlgeschlagen!");
  	  											$session->clear('input_Site');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_user_exist_already'){ Login::html_testseite("Die Registrierung fehlgeschlagen! Den Benutzer gibt es bereits!");
  	  											$session->clear('input_Site');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_password_not_equal'){ Login::html_testseite("Die Registrierung fehlgeschlagen! Die 2 eingegebenen Passwörter sind nicht identisch!");
  	  											$session->clear('input_Site');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Dummy.cgi'}); }
  											
  when('Registration_textfields_incomplete'){ Login::html_testseite("Die Registrierung fehlgeschlagen! Es wurden nicht alle Felder ausgefuellt!");
  	  											$session->clear('input_Site');
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Login_check')					 { if( ($session->param('input_Login') ne 'E-Mail Adresse') && $session->param('input_Password') ne "" )	#Ueberpruefe ob tatsächlich was eingegeben wurde, ansonsten leite auf die Loginseite um
  									  		{
  									  			#Hier wird ueberprueft ob der User&Passwort korrekt sind, mit dem Status(rueckgabewert) wird weiterverfahren
  									  			my $value = db_Login::login_User($session->param('input_Login'),$session->param('input_Password'));	
  									  			$session->param('input_Site', $value);	
  									  			print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'});								  			
  									  		}				 
  											else
  											{
  												Login->html_login();
  											}
  										 }
  										 
  when('Login_valid')					 { 
  											
  											Login::html_testseite("Login war erfolgreich, trage Session in DB ein");
  											db_access::set_Hash($session->param('input_Login'),$session->id());											
  														
  										  }
 
  when('Login_invalid')					 { 
  											Login::html_testseite("Login fehlerhaft!");
  											$session->clear('input_Site');  											
  										  }
  										  
  										 
  default								 { print $cgi->h1("Problem mit der Websitenauswahl") }
}

#$session->clear('input_Site');	#Verhindert dass immer wieder die Seite angezeigt wird, welche als letztes aufgerufen wurde (Beispiel Registration)

