#!perl -w 

#Dies verarbeitet die Eingaben/Steuerung der Seitenansicht und setzt bestimmte
#Werte in den Sessions mit denen weitergearbeitet wird

use CGI::Session;
use feature qw {switch};
use strict; 
use CGI; 
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
my $session = CGI::Session->new($cgi);

# print the HTTP header and set the session ID cookie
print $session->header();
#print $session->param('setContent');
print $cgi->param('setContent');

#alle uebergebenen Parameter speichern
$session->save_param($cgi);

given ($cgi->param('setContent')){
#  when( undef )							 { Login::html_login(); } 
  
  when('create_Ticket')	 			 { $session->param('setContent',"submit_create_Ticket");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('dfg')	 	 	{ $session->param('input_Site',"Registration_check");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_successfull')	 	{ $session->param('input_Site',"Registration_successfull");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_failed')	 	 	 { $session->param('input_Site',"Registration_failed");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  
  when('Registration_user_exist_already'){ $session->param('input_Site',"Registration_user_exist_already");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  											
  when('Registration_password_not_equal'){ $session->param('input_Site',"Registration_password_not_equal");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  											 
  when('Login_check')					 { $session->param('input_Site',"Login_check");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  										 
  when('Login_valid')					{ $session->param('input_Site',"Login_valid");
  											print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Dummy.cgi'}); }
  										 
  default								 { print $cgi->h1("Problem mit dem setSession-Modul") }
}