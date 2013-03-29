#!perl -w 

#Dies soll die Verwaltung der Useransicht sein

use CGI::Session;
use feature qw {switch};
use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Login 'html_testseite'; 
use db_Login 'login_User', 'regist_User';
use db_access 'set_Hash', 'get_Hash';
use setUserContent 'print_createTicket', 'print_Punkt2', 'print_Punkt3', 'print_Punkt4', 'print_Start', 'print_submit_create_Ticket'; 
 
 #----------------------------------------
 #Instanzvariablen
 #----------------------------------------
my $cgi = new CGI;
my $setContent;
# new session object, will get session ID from the query object
# will restore any existing session with the session ID in the query object
my $session = CGI::Session->new($cgi);
my $user = $session->param('User');

$setContent = $cgi->param('setContent');
my $sessionContent = $session->param('setContent');



# print the HTTP header and set the session ID cookie
print $session->header();

print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Userbereich',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Userbereich'},
                       -style  =>{'src'=>'../../css/Style.css'}
                       );
                       
#Begin des Wrappers

     print $cgi->start_div({-id=>'user_wrapper'});
     print $cgi->start_div({-id=>'user_header'});
     print $cgi->h1(
     				$cgi->center("Header! Willkommen $user, cgicontent: $setContent, Sessioncontent: $sessionContent")
     				);
     print $cgi->end_div({-id=>'user_header'});
	 print $cgi->start_div({-id=>'user_menu'});
	
	 print '<a href="User.cgi?setContent=create_Ticket" TARGET="_self">Neues Ticket</a><br>';
	 print '<a href="User.cgi?setContent=Punkt2" TARGET="_self">Punkt2</a><br>';
	 print '<a href="User.cgi?setContent=Punkt3" TARGET="_self">Punkt3</a><br>';
	 print '<a href="User.cgi?setContent=Punkt4" TARGET="_self">Punkt4</a><br>';
    
     print $cgi->end_div({-id=>'user_menu'});
     print $cgi->start_div({-id=>'user_content'});
	 #Hier muss der "richtige" Content ausgewaehlt und angezeigt werden
	 given ($setContent){
	 	when( undef )				{setUserContent::print_Start();}
	 	when('create_Ticket')		{setUserContent::print_createTicket();}
	 	when('Punkt2')				{setUserContent::print_Punkt2();}
	 	when('Punkt3')				{setUserContent::print_Punkt3();}
	 	when('Punkt4')				{setUserContent::print_Punkt4();}
	 	when('submit_create_Ticket'){setUserContent::print_submit_create_Ticket($user,$session->param('input_Betreff'),$session->param('input_Message'),1,1); 
									}	 	
						 }

     print $cgi->end_div({-id=>'user_content'});
     print $cgi->end_div({-id=>'user_wrapper'});
     
print $cgi->end_html();