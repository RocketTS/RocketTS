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
use CGI::Session;
use CGI::Carp qw(fatalsToBrowser);
use DebugUtils;
use UserContent;
use MitarbeiterContent;


#########################################
#Instanzvariablen						#
#########################################

#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
#mit der Session-ID
my $cgi = new CGI;

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
#Mitarbeiter her
my $session = CGI::Session->new($cgi);

#Ueberpruefe ob die Rechte des Clienten passen, falls nicht log den Clienten aus und leite zur Root weiter
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

	print $cgi->start_div({-id=>'user_wrapper'});
	print $cgi->start_div({-id=>'user_header'});
	print $cgi->h1($cgi->center("Ticketsystem Rocket"));
	print $cgi->end_div({-id=>'user_header'});
	print $cgi->start_div({-id=>'user_menu'});

	#Ausgabe des Navigationsbereichs	
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
		      <h4>Einstellungen</h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Password" TARGET="_self">Passwort</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Email" TARGET="_self">Email</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_delete_Account" TARGET="_self">Account l�schen</a></li>
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
		when( '' )						{UserContent::print_Index();}
		when('show_newTickets')			{MitarbeiterContent::print_show_newTickets();}
		when('show_inprocessTickets')	{MitarbeiterContent::print_show_inprocessTickets();}
		when('show_History')			{MitarbeiterContent::print_show_History();}
		when('show_Statistik')			{MitarbeiterContent::print_Statistik();}
		when('show_User')				{MitarbeiterContent::print_UserList();}
		when('show_specUser')			{MitarbeiterContent::print_show_specUser();}
		when('show_specTicket')			{MitarbeiterContent::print_show_specTicket();}

		when('submit_assumeTicket')		{MitarbeiterContent::print_submit_assumeTicket($session->param('UserIdent'),$session->param('specificTicket'));}
		when('submit_forwardTicket')	{MitarbeiterContent::print_submit_forwardTicket($session->param('UserIdent'),$session->param('specificTicket'));}
		when('submit_releaseTicket')	{MitarbeiterContent::print_submit_releaseTicket($session->param('UserIdent'),$session->param('specificTicket'));}	
		when('submit_closeTicket')		{MitarbeiterContent::print_submit_closeTicket($session->param('UserIdent'),$session->param('specificTicket'));}
		when('submit_answerTicket') 	{UserContent::print_answerTicket($session->param('UserIdent'),$session->param('specificTicket'),$session->param('UserMessage'));}	
		
		#Von User.cgi �bernommen
		when('show_Einstellungen')	{
			given ($session->param('ShowPage_Level3'))
										{
											when( 'show_Password' )			{UserContent::print_show_Einstellungen("Password");}
											when( 'show_Email' )			{UserContent::print_show_Einstellungen("Email");}
											when( 'show_delete_Account' )	{UserContent::print_show_Einstellungen("delete_Account");}
										}
		}
		when('changePassword')		{given ($session->param('ShowPage_Level3'))
										{
											when( 'checkPassword' )	{#Das Modul changePassword �berpr�ft nun ob die �nderung eingetragen werden kann, und gibt eine Statusmeldung zur�ck mit der weitergearbeitet wird
																	 my $status = UserDB::changePassword($session->param('UserIdent'),$session->param('UserPassword'),$session->param('newPassword1'),$session->param('newPassword2'));
																	 $session->param('ShowPage_Level3',$status);
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when('missing'){
																	 print $cgi->h1("Fehler: Nicht alle geforderten Passw�rter eingegeben!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Password");
																	 $session->flush();
																 	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	 }
											when('not_equal'){
																	print $cgi->h1("Fehler: Die neuen Passw�rter waren nicht identisch!");	
																	$session->param('ShowPage_Level2',"show_Einstellungen");
																	$session->param('ShowPage_Level3',"show_Password");
																	$session->flush();
																	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	 }
											when('incorrect'){
																	print $cgi->h1("Fehler: Vorhandene Passw�rter stimmen nicht �berein!");	
																	$session->param('ShowPage_Level2',"show_Einstellungen");
																	$session->param('ShowPage_Level3',"show_Password");
																	$session->flush();
																	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	 }
											when('success'){
																	print $cgi->h1("Password wurde erfolgreich ge�ndert!");	
																	$session->param('ShowPage_Level2',"");
																	$session->flush();
																	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	 }
											when('failed'){
																	print $cgi->h1("Es trat ein Fehler beim Speichern des neues Passwortes auf!");	
																	$session->param('ShowPage_Level2',"show_Einstellungen");
																	$session->param('ShowPage_Level3',"show_Password");
																	$session->flush();
																	print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	 }
										}
									}
									 
		when('deleteAccount')		{
										given ($session->param('ShowPage_Level3'))
										{
											when( 'checkPassword' )	{my $status = UserDB::deleteAccount($session->param('UserIdent'),$session->param('UserPassword'));
																	 $session->param('ShowPage_Level3',$status);
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'missing' )		{print $cgi->h1("Fehler: Passwort wurde nicht eingegeben!");	
																	 $session->param('ShowPage_Level2',"deleteAccount");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'incorrect' )		{print $cgi->h1("Fehler: Passwort war nicht korrekt!");	
																	 $session->param('ShowPage_Level2',"deleteAccount");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'success' )		{print $cgi->h1("Der Account wurde erfolgreich gel�scht. Sie werden nun ausgeloggt!");	
																	 $session->param('ShowPage_Level1',"Logout");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'failed' )		{print $cgi->h1("Fehler: Es trat ein Datenbankfehler beim L�schen auf!");	
																	 $session->param('ShowPage_Level2',"deleteAccount");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
										}
		}
	}

	     print $cgi->end_div({-id=>'user_content'});
	     print $cgi->end_div({-id=>'user_wrapper'});
     
	print $cgi->end_html();
}

