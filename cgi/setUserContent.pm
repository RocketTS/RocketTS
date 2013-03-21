#!perl -w 

#setUserContent soll Funktionen bereithalten die zu dem ausgewaehlten
#Menupunkt die Daten auf dem "Content-Bereich" der Website darstellen

package setUserContent;
use strict; 
use Exporter;
use db_access 'create_Ticket';

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(print_createTicket print_Punkt2 print_Punkt3 print_Punkt4 print_Start print_submit_create_Ticket);


 sub print_User_Testseite
 {#Uebergabeparameter: String der ausgegeben werden soll
  #Diese Subroutine ist für den Content-Bereich der Useransicht angepasst
  my $text = $_[0];
  my $cgi = CGI->new();
  print $cgi->h1($text);
  	1;		
 }

 sub print_createTicket
 {#Gibt den Content von Punkt1 aus
 	my $cgi = CGI->new();
	my $session = CGI::Session->new($cgi);
	$session->param('setContent', "submit_create_Ticket");
	
	 print $cgi->start_html();
	 print $cgi->h2("Neues Ticket erstellen");
	 
	 print $cgi->start_form({-method => "POST",
	 						-action => "/cgi-bin/rocket/setSessionUser.cgi",
	 						-target => '_self'
	 						 });
	 
 	 print $cgi->hidden(-name=>'setContent',
	 				   -value=>'submit_create_Ticket');
	 				   
	 print $cgi->strong("Betreff\t");
	 
	 print $cgi->textfield(-name=>'input_Betreff',
	 					  -value=>'',
	 					  -size=>50,
	 					  -maxlength=>50);
	 print $cgi->br();
	 
	 print $cgi->strong("Nachricht\t");	
	 						
	 print $cgi->textarea(-name=>'input_Message',
	 						   -value=>'',
	 						   -cols=>70,
	 						   -rows=>10);
	 print $cgi->br();
	 print $cgi->submit("Erstellen");
	 print $cgi->end_form();
 }
 
 sub print_submit_create_Ticket
 {#Subroutine versucht das Ticket in die Datenbank einzutragen
 	my($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID) = @_;
 	my $eingetragen = db_access::create_Ticket($Username,$Betreff,$Message,$Auswahl_ID,$Prioritaet_ID);
 	if($eingetragen != 0)
 	{
 		print_User_Testseite("Ticket wurde erfolgreich uebermittelt!");
 	}
 	else
 	{
 		print_User_Testseite("Fehler! Ticket konnte nicht uebermittelt werden!");
 	}
 	1;
 }
 
 sub print_Punkt2
 {#Gibt den Content von Punkt2 aus
  print_User_Testseite("Punkt2");
 }
 
 sub print_Punkt3
 {#Gibt den Content von Punkt3 aus
  print_User_Testseite("Punkt3");
 }
 
 sub print_Punkt4
 {#Gibt den Content von Punkt4 aus
  print_User_Testseite("Punkt4");
 }
 
  sub print_Start
 {#Gibt den Content von Punkt4 aus
  print_User_Testseite("Index Seite von Userbereich \\m/");
 }