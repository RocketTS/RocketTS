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
use DebugUtils;
use UserContent;


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
	print $cgi->h1($cgi->center("Ticketsystem Rocket"));
	print $cgi->end_div({-id=>'user_header'});
	print $cgi->start_div({-id=>'user_menu'});
	
	#Jetzt kommt der HTML-Code, welcher das komplette Menü darstellt	
	print '<nav>
		    <div class="menu-item-static">
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
		      <h4>Einstellungen</h4>
		      <ul>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Password" TARGET="_self">Passwort</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_Email" TARGET="_self">Email</a></li>
		        <li><a href="SaveformData.cgi?Level2=show_Einstellungen&Level3=show_delete_Account" TARGET="_self">Account löschen</a></li>
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
											when( 'show_Password' )			{UserContent::print_show_Einstellungen("Password");}
											when( 'show_Email' )			{UserContent::print_show_Einstellungen("Email");}
											when( 'show_delete_Account' )	{UserContent::print_show_Einstellungen("delete_Account");}
										}
									
									 
									 }
		when('submit_createTicket')	{UserContent::print_submit_createTicket($session->param('UserIdent'),$session->param('UserMessageTopic'),$session->param('UserMessage'),$session->param('TicketCategorie'),3); }
		#Der Wert 3 am Ende ist die Standartpriority, mit der ein neues Ticket in die Datenbank eingetragen wird	 
		when('submit_answerTicket') {UserContent::print_answerTicket($session->param('UserIdent'),$session->param('specificTicket'),$session->param('UserMessage'));}
		when('changePassword')		{#Das Modul changePassword überprüft nun ob die Änderung eingetragen werden kann, und gibt eine Statusmeldung zurück mit der weitergearbeitet wird
									 my $status = UserDB::changePassword($session->param('UserIdent'),$session->param('UserPassword'),$session->param('newPassword1'),$session->param('newPassword2'));
									 $session->param('ShowPage_Level2',$status);
									 $session->flush();
									 print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});
									}
		when('changePassword_missing'){
										print $cgi->h1("Fehler: Nicht alle geforderten Passwörter eingegeben!");	
										$session->param('ShowPage_Level2',"show_Einstellungen");
										$session->flush();
										print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
									 }
		when('changePassword_not_equal'){
										print $cgi->h1("Fehler: Die neuen Passwörter waren nicht identisch!");	
										$session->param('ShowPage_Level2',"show_Einstellungen");
										$session->flush();
										print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
									 }
		when('changePassword_incorrect'){
										print $cgi->h1("Fehler: Vorhandenen Passwörter stimmen nicht überein!");	
										$session->param('ShowPage_Level2',"show_Einstellungen");
										$session->flush();
										print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
									 }
		when('changePassword_success'){
										print $cgi->h1("Password wurde erfolgreich geändert!");	
										$session->param('ShowPage_Level2',"");
										$session->flush();
										print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
									 }
		when('changePassword_failed'){
										print $cgi->h1("Es trat ein Fehler beim Speichern des neues Passwortes auf!");	
										$session->param('ShowPage_Level2',"show_Einstellungen");
										$session->flush();
										print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
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
											when( 'success' )		{print $cgi->h1("Der Account wurde erfolgreich gelöscht. Sie werden nun ausgeloggt!");	
																	 $session->param('ShowPage_Level1',"Logout");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'failed' )		{print $cgi->h1("Fehler: Es trat ein Datenbankfehler beim Löschen auf!");	
																	 $session->param('ShowPage_Level2',"deleteAccount");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
										}
									 }
										
		when('changeEmail')			{
										given ($session->param('ShowPage_Level3'))
										{
											when( 'checkPassword' )	{my $status = UserDB::changeEmail($session->param('UserIdent'),$session->param('newPassword1'),$session->param('newEmail'));
																	 $session->param('ShowPage_Level3',$status);
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'missing_password' ){print $cgi->h1("Fehler: Passwort wurde nicht eingegeben!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Email");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'missing_email' )	{print $cgi->h1("Fehler: Neue Email-Adresse wurde nicht eingegeben!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Email");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'incorrect' )		{print $cgi->h1("Fehler: Passwort war nicht korrekt!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Email");
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'success' )		{print $cgi->h1("Die Email-Adresse wurde erfolgreich geändert!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Email");
																	 #Da die Email-Adresse als UserIdent gehandhabt wird, muss diese natürlich auch in der bestehenden Session upgedated werden
																	 $session->param('UserIdent', $session->param('newEmail'));
																	 $session->flush();
																	 print $cgi->meta({-http_equiv => 'REFRESH', -content => '3; /cgi-bin/rocket/Rocket.cgi'});
																	}
											when( 'failed' )		{print $cgi->h1("Fehler: Es trat ein Datenbankfehler beim Ändern der Email-Adresse auf!");	
																	 $session->param('ShowPage_Level2',"show_Einstellungen");
																	 $session->param('ShowPage_Level3',"show_Email");
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
