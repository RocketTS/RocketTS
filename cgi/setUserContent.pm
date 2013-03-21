#!perl -w 

#setUserContent soll Funktionen bereithalten die zu dem ausgewaehlten
#Menupunkt die Daten auf dem "Content-Bereich" der Website darstellen

package setUserContent;
use strict; 
use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(print_Punkt1 print_Punkt2 print_Punkt3 print_Punkt4 print_Start);


 sub print_User_Testseite
 {#Uebergabeparameter: String der ausgegeben werden soll
  #Diese Subroutine ist für den Content-Bereich der Useransicht angepasst
  my $text = $_[0];
  my $cgi = CGI->new();
  print $cgi->h1($text);
  	1;		
 }

 sub print_Punkt1
 {#Gibt den Content von Punkt1 aus
  print_User_Testseite("Punkt1");
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