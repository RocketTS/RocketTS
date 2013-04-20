#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 06.03.2013                    #
########################################
#Beschreibung: Stellt Subroutinen bereit um das Debuggen des Projektes zu Erleichtern

package DebugUtils;

use strict; 
use Exporter;
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an


sub html_testseite
{	#Aufruf: 	   html_testseite("Dieser Text soll in einer HTMl-Seite dargestellt werden");
	#Beschreibung: Der Funktion wird ein Text mitgegeben, welcher in einer kompletten HTML-Seite eingebettet wird.
	#			   Wurde bei der Entwicklung des Projekts oft verwendet, um den Ablauf der Scripte zu testen
	#Rückgabewert: Keiner
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
     				$cgi->center("Ticketsystem")
     				);
     print $cgi->end_div();
     

	 #Ausgabe des Bodys
	 print $cgi->start_div({-id=>'login_body'});
	 
	 print $cgi->h2($text);
	 
	 
	 print $cgi->end_div();
     print $cgi->end_html();
  	
 }
 1;