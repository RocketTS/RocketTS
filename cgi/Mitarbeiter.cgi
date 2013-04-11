#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 02.04.2013                    #
########################################
#Description: Level1: Mitarbeiter
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es verwaltet die Ansicht des Mitarbeiter-Bereiches

use CGI::Session;
use feature qw {switch};
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils 'html_testseite';
use MitarbeiterContent 'printIndex';
use LoginDB 'regist_User';


#########################################
#Instanzvariablen						#
#########################################

#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
#mit der Session-ID
my $cgi = new CGI;

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
#Mitarbeiter her
my $session = CGI::Session->new($cgi);

#Ueberpruefe ob die Rechte des Clienten passen, falls nicht log
#den Clienten aus und leite zur Root weiter
if($session->param('AccessRights') ne "Mitarbeiter")
{	#Rechte passen nicht, loesche Session (ausloggen)
	$session->clear();
	$session->flush();
	print $cgi->header();
	DebugUtils::html_testseite("Unauthorisierter Zugriff auf Mitarbeiterbereich!! Du wirst ausgeloggt!");
	print $cgi->meta({-http_equiv => 'REFRESH', -content => '5; /cgi-bin/rocket/Rocket.cgi'});
}
else
{
	#Ausgabe des Headers
	print $session->header();

	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Mitarbeiterbereich',
	 						-author =>'beispiel@example.org',
	                       -base   =>'true',
	                       -target =>'_blank',
	                       -meta   =>{'keywords'   =>'TeamOne, Test',
	                                  'description'=>'Mitarbeiterbereich'},
	                       -style  =>{'src'=>'../../css/Style.css'}
	                       );
                       
	#Ausgabe des Wrappers, damit wird das Grundgeruest der Seite ausgegeben

	print $cgi->start_div({-id=>'ma_wrapper'});
	print $cgi->start_div({-id=>'ma_header'});
	print $cgi->h1($cgi->center("Header! Willkommen Mitarbeiter"));
	print $cgi->end_div({-id=>'ma_header'});
	print $cgi->start_div({-id=>'ma_menu'});
	
#	print '<b>Tickets</b><br>';
#	print '<a href="SaveformData.cgi?Level2=show_newTickets" TARGET="_self">Neue Tickets</a><br>';
#	print '<a href="SaveformData.cgi?Level2=show_inprocessTickets" TARGET="_self">In Bearbeitung</a><br>';
#	print '<a href="SaveformData.cgi?Level2=show_History" TARGET="_self">History</a><br>';
#	print '<a href="SaveformData.cgi?Level2=show_Statistik" TARGET="_self">Statistik</a><br>';
#	print '<br><br><b>Benutzerverwaltung</b><br>';
#	print '<a href="SaveformData.cgi?Level2=show_User" TARGET="_self">Übersicht Benutzer</a><br>';
	
	print '<nav>
		    <div class="menu-item-static">
		      <h4>Tickets</h4>
		      <ul>
		      <li><a href="SaveformData.cgi?Level2=show_newTickets" TARGET="_self">Neue Tickets</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_inprocessTickets" TARGET="_self">in Bearbeitung</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_History" TARGET="_self">History</a></li>
		      <li><a href="SaveformData.cgi?Level2=show_Statistik" TARGET="_self">Statistik</a></li>
		      </ul>
		    </div>
		      
		    <div class="menu-item">
		      <h4><a href="#">Verwaltung</a></h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level2=show_User" TARGET="_self">Benutzerübersicht</a></li>
		      </ul>
		    </div>
		</nav>';
    
	print $cgi->end_div({-id=>'ma_menu'});
	print $cgi->start_div({-id=>'ma_content'});
	#Hier muss der "richtige" Content ausgewaehlt und angezeigt werden (Level2)

	given ($session->param('ShowPage_Level2'))
	{
		when( '' )						{MitarbeiterContent::print_Index();}
		when('show_newTickets')			{MitarbeiterContent::print_show_newTickets();}
		when('show_inprocessTickets')	{MitarbeiterContent::print_show_inprocessTickets();}
		when('show_History')			{MitarbeiterContent::print_show_History();}
		when('show_Statistik')			{MitarbeiterContent::print_Statistik();}
		when('show_User')				{MitarbeiterContent::print_show_User();}
		when('show_specTicket')			{MitarbeiterContent::print_show_specTicket();}
		when('submit_assumeTicket')		{MitarbeiterContent::print_submit_assumeTicket($session->param('UserIdent'),$session->param('specificTicket'));}
		when('submit_forwardTicket')	{MitarbeiterContent::print_submit_forwardTicket($session->param('UserIdent'),$session->param('specificTicket'));}
		when('submit_releaseTicket')	{MitarbeiterContent::print_submit_releaseTicket($session->param('UserIdent'),$session->param('specificTicket'));}	
		when('submit_closeTicket')		{MitarbeiterContent::print_submit_closeTicket($session->param('UserIdent'),$session->param('specificTicket'));}
	#	when('submit_createTicket')		{UserContent::print_submit_createTicket($session->param('UserIdent'),$session->param('UserMessageTopic'),$session->param('UserMessage'),1,1); }	 	
		when('submit_answerTicket') 	{MitarbeiterContent::print_answerTicket($session->param('UserIdent'),$session->param('specificTicket'),$session->param('UserMessage'));}	
	}

	     print $cgi->end_div({-id=>'ma_content'});
	     print $cgi->end_div({-id=>'ma_wrapper'});
     
	print $cgi->end_html();
}
