#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 11.04.2013                    #
########################################
#Description: Level1: Administrator
#Dieses Script wird nur von Root (Rocket.cgi) aufgerufen
#Es verwaltet die Ansicht des Mitarbeiter- und des Administrator-Bereiches (da jeder Admin ja auch ein Mitarbeiter ist)

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

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen Mitarbeiter her
my $session = CGI::Session->new($cgi);

#Ueberpruefe ob die Rechte des Clienten passen, falls nicht log
#den Clienten aus und leite zur Root weiter
if($session->param('AccessRights') ne "Administrator")
{	#Rechte passen nicht, loesche Session (ausloggen)
	$session->clear();
	$session->flush();
	print $cgi->header();
	DebugUtils::html_testseite("Unauthorisierter Zugriff auf Administratorbereich!! Du wirst ausgeloggt!");
	print $cgi->meta({-http_equiv => 'REFRESH', -content => '5; /cgi-bin/rocket/Rocket.cgi'});
}
else
{
	#Ausgabe des Headers
	print $session->header();

	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! Administrationsbereich',
	 						-author =>'beispiel@example.org',
	                       -base   =>'true',
	                       -target =>'_blank',
	                       -meta   =>{'keywords'   =>'TeamOne, Test',
	                                  'description'=>'Administrationsbereich'},
	                       -style  =>{'src'=>'../../css/Style.css'}
	                       );
                       
	#Ausgabe des Wrappers, damit wird das Grundgeruest der Seite ausgegeben

	print $cgi->start_div({-id=>'user_wrapper'});
	print $cgi->start_div({-id=>'user_header'});
	print $cgi->h1($cgi->center("Header! Willkommen " .$session->param('UserIdent')));
	print $cgi->end_div({-id=>'user_header'});
	print $cgi->start_div({-id=>'user_menu'});
		
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
		    
		    <div class="menu-item">
		      <h4><a href="#">Administration</a></h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level2=show_Mitarbeiter" TARGET="_self">Mitarbeiterverwaltung</a></li>
		      </ul>
		    </div>
		    
		    <div class="menu-item">
		      <h4>Logout</h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level1=Logout" TARGET="_self">Abmelden</a></li>
		      </ul>
		    </div>
		</nav>';
    
	print $cgi->end_div({-id=>'user_menu'});
	print $cgi->start_div({-id=>'user_content'});
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
		when('submit_answerTicket') 	{MitarbeiterContent::print_answerTicket($session->param('UserIdent'),$session->param('specificTicket'),$session->param('UserMessage'));}	
		#Zusatz zu Mitarbeitern für Administatoren
		when('show_Mitarbeiter')		{AdministratorContent::print_show_Mitarbeiter();}
	}

	     print $cgi->end_div({-id=>'user_content'});
	     print $cgi->end_div({-id=>'user_wrapper'});
     
	print $cgi->end_html();
}
