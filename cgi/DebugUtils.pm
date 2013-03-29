#!perl -w 

#Test-Modul welches paar Debug-Funktionen bereitstellt

package DebugUtils;

use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
use Exporter;

#our @ISA = qw(Exporter);

our @EXPORT_OK = qw(html_testseite);


sub html_testseite
 {#Uebergabeparameter: Der Text, der als Ueberschrift ausgegeben werden soll	
 	my $text = $_[0];
 	my $cgi = CGI->new();
 	my $session = CGI::Session->new($cgi);
 	#print $session->header();

                   			
 	print $cgi->start_html(-title  =>'Ticketsystem Team Rocket! SID ',
 						-author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../css/Style.css'}
                       );


     #Ausgabe des Headers
     print $cgi->start_div({-id=>'login_header'});
     print $cgi->h1(
     				$cgi->center("Ticketsystem".$session->id())
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Bodys
	 print $cgi->start_div({-id=>'login_body'});
	 
	 print $cgi->h2($text);
	 
	 
	 print $cgi->end_div();
    print $cgi->end_html();
  	1;	
 }