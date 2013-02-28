#!"C:\xampp\perl\bin\perl.exe" -w -T

#Dies soll das Login-Frontend sein

use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an
 
my $cgi = new CGI; 

print $cgi->header(-type    =>'text/html',
                   -expires =>'+1s'),
      $cgi->start_html(-title  =>'Ticketsystem Team Rocket!',
                       -author =>'beispiel@example.org',
                       -base   =>'true',
                       -target =>'_blank',
                       -meta   =>{'keywords'   =>'TeamOne, Test',
                                  'description'=>'Loginseite'},
                       -style  =>{'src'=>'../../styles/Schulprojekt/Login.css'},
                       -BGCOLOR=>'lightgreen',
                       -TEXT   =>'#000000',
                       -LINK   =>'red',
                       -VLINK  =>'blue',
                       -ALINK  =>'black'),
      $cgi->h1('  ');
	  print "<center><div class = 'header'>";
	  print "<h1>Ticketsystem</h1>";
	  print "</div>";
	  
	  print "<div class = 'body'>";
	  print "<h2>Login: </h2>";
	  print"</div></center>";
      $cgi->end_html();