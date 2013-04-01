#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Level1: User
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es verwaltet die Ansicht des User-Bereiches

use CGI::Session;
use feature qw {switch};
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils 'html_testseite';
use UserContent 'printIndex';
use LoginDB 'regist_User';


#########################################
#Instanzvariablen						#
#########################################

#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
#mit der Session-ID
my $cgi = new CGI;

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
#User her
my $session = CGI::Session->new($cgi);

#Ueberpruefe ob die Rechte des Clienten passen, falls nicht log
#den Clienten aus und leite zur Root weiter
if($session->param('AccessRights') ne "User")
{	#Rechte passen nicht, loesche Session (ausloggen)
	$session->clear();
	$session->flush();
	print $cgi->header();
	DebugUtils::html_testseite("Unauthorisierter Zugriff!! Du wirst ausgeloggt!");
	print $cgi->meta({-http_equiv => 'REFRESH', -content => '5; /cgi-bin/rocket/Rocket.cgi'});
}
else
{
	#Ausgabe des Headers
	print $session->header();

	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Userbereich',
	 						-author =>'beispiel@example.org',
	                       -base   =>'true',
	                       -target =>'_blank',
	                       -meta   =>{'keywords'   =>'TeamOne, Test',
	                                  'description'=>'Userbereich'},
	                       -style  =>{'src'=>'../../css/Style.css'}
	                       );
                       
	#Ausgabe des Wrappers, damit wird das Grundgeruest der Seite ausgegeben

	print $cgi->start_div({-id=>'user_wrapper'});
	print $cgi->start_div({-id=>'user_header'});
	print $cgi->h1($cgi->center("Header! Willkommen"));
	print $cgi->end_div({-id=>'user_header'});
	print $cgi->start_div({-id=>'user_menu'});
	
	print '<a href="SaveformData.cgi?Level2=createTicket" TARGET="_self">Neues Ticket</a><br>';
	print '<a href="SaveformData.cgi?Level2=show_ownTickets" TARGET="_self">Erstellte Tickets</a><br>';
	print '<a href="SaveformData.cgi?Level2=Punkt3" TARGET="_self">Punkt3</a><br>';
	print '<a href="SaveformData.cgi?Level2=Punkt4" TARGET="_self">Punkt4</a><br>';
    
	print $cgi->end_div({-id=>'user_menu'});
	print $cgi->start_div({-id=>'user_content'});
	#Hier muss der "richtige" Content ausgewaehlt und angezeigt werden (Level2)

	given ($session->param('ShowPage_Level2'))
	{
		when( '' )					{UserContent::print_Index();}
		when('createTicket')		{UserContent::print_createTicket();}
		when('show_ownTickets')		{UserContent::print_show_ownTickets();}
		when('show_specTicket')		{UserContent::print_show_specTicket();}
		when('Punkt4')				{UserContent::print_Punkt4();}
		when('submit_createTicket')	{UserContent::print_submit_createTicket($session->param('UserIdent'),$session->param('UserMessageTopic'),$session->param('UserMessage'),1,1); }	 	
	}

	     print $cgi->end_div({-id=>'user_content'});
	     print $cgi->end_div({-id=>'user_wrapper'});
     
	print $cgi->end_html();
}
