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
	
#	print '<a href="SaveformData.cgi?Level2=createTicket" TARGET="_self">Neues Ticket</a><br>';
#	print '<a href="SaveformData.cgi?Level2=show_ownTickets&Level3=all" TARGET="_self">Erstellte Tickets</a><br>';
#	if($session->param('ShowPage_Level2') eq "show_ownTickets")
#	{#Falls die "Eigenen Tickets" angeklickt wurden, zeige die 3 Menueunterpunkte
#	 #1. Offen
#	 #2. In Bearbeitung
#	 #3. Geschlossen
#	 print '<a href="SaveformData.cgi?Level3=show_open" TARGET="_self">  ->Offen</a><br>';
#	 print '<a href="SaveformData.cgi?Level3=show_in_use" TARGET="_self">  ->In Bearbeitung</a><br>';
#	 print '<a href="SaveformData.cgi?Level3=show_closed" TARGET="_self">  ->Geschlossen</a><br>';
#	}
#	print '<a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=all" TARGET="_self">Einstellungen</a><br>';
#	if($session->param('ShowPage_Level2') eq "show_Einstellungen")
#	{#Falls die "Einstellungen" angeklickt wurden, zeige die 3 Menueunterpunkte
#	 #1. Password
#	 #2. Email
#	 #3. Account löschen
#	 print '<a href="SaveformData.cgi?Level3=show_Password" TARGET="_self">  ->Passwort</a><br>';
#	 print '<a href="SaveformData.cgi?Level3=show_Email" TARGET="_self">  ->Email</a><br>';
#	 print '<a href="SaveformData.cgi?Level3=show_delete_Account" TARGET="_self">  ->Account löschen</a><br>';
#	}
#	print '<a href="SaveformData.cgi?Level1=Logout" TARGET="_self">Logout</a><br>';
#    
#	print $cgi->end_div({-id=>'user_menu'});


#Hier kommt eine alternative Menüansicht

print '<nav>
		    <div class="menu-item">
		      <h4>Tickets</h4>
		      <ul>
		      <li><a href="SaveformData.cgi?Level2=createTicket" TARGET="_self">Neues Ticket</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_ownTickets&Level3=all" TARGET="_self">Erstellte Tickets</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_ownTickets&Level3=show_open" TARGET="_self">Offene Tickets</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_ownTickets&Level3=show_in_use" TARGET="_self">In Bearbeitung</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_ownTickets&Level3=show_closed" TARGET="_self">Geschlossen</a></li>
		      </ul>
		    </div>
		      
		    <div class="menu-item">
		      <h4><a href="#">Einstellungen</a></h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Password" TARGET="_self">Passwort</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Email" TARGET="_self">Email</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_delete_Account" TARGET="_self">Account löschen</a></li>
		      </ul>
		    </div>
		      
		    <div class="menu-item">
		      <h4><a href="#">About</a></h4>
		      <ul>
		        <li><a href="#">History</a></li>
		        <li><a href="#">Meet The Owners</a></li>
		        <li><a href="#">Awards</a></li>
		      </ul>
		    </div>
		      
		    <div class="menu-item">
		      <h4><a href="#">Contact</a></h4>
		      <ul>
		        <li><a href="#">Phone</a></li>
		        <li><a href="#">Email</a></li>
		        <li><a href="#">Location</a></li>
		      </ul>
		    </div>
		</nav>';
	print $cgi->end_div({-id=>'user_menu'});


	#Hier muss der "richtige" Content ausgewaehlt und angezeigt werden (Level2)
	print $cgi->start_div({-id=>'user_content'});


	given ($session->param('ShowPage_Level2'))
	{
		when( '' )					{UserContent::print_Index();}
		when('createTicket')		{UserContent::print_createTicket();}
		when('show_ownTickets')		{given ($session->param('ShowPage_Level3'))
										{
											when( 'all' )			{UserContent::print_show_ownTickets("Alle");}
											when( 'show_open' )		{UserContent::print_show_ownTickets("Neu");}
											when( 'show_in_use' )	{UserContent::print_show_ownTickets("Bearbeitung");}
											when( 'show_closed' )	{UserContent::print_show_ownTickets("Geschlossen");}
										}
									
									 
									 }
		when('show_specTicket')		{UserContent::print_show_specTicket();}
		when('show_Einstellungen')	{given ($session->param('ShowPage_Level3'))
										{
											when( 'all' )					{UserContent::print_show_Einstellungen("Alle");}
											when( 'show_Password' )			{UserContent::print_show_Einstellungen("Password");}
											when( 'show_Email' )			{UserContent::print_show_Einstellungen("Email");}
											when( 'show_delete_Account' )	{UserContent::print_show_Einstellungen("delete_Account");}
										}
									
									 
									 }
		when('submit_createTicket')	{UserContent::print_submit_createTicket($session->param('UserIdent'),$session->param('UserMessageTopic'),$session->param('UserMessage'),1,1); }	 
		when('submit_answerTicket') {UserContent::print_answerTicket($session->param('UserIdent'),$session->param('specificTicket'),$session->param('UserMessage'));}	
	}
	
	print $cgi->end_div({-id=>'user_content'});
	print $cgi->end_div({-id=>'user_wrapper'});
     
	print $cgi->end_html();
}
