#!perl -w
########################################
#Author: Thomas Dorsch                 #
#Date: 	 29.03.2013                    #
########################################
#Description: Uebernimmt Daten aus voheriger
#Form und speichert diese in die Session des
#Users
#Danach wird immer Root (Rocket.cgi) aufgerufen


use CGI::Session;
use strict; 
use CGI; 
use CGI::Carp qw(fatalsToBrowser);  	#Zeige die Fehlermeldungen im Browser an


#Erstelle ein neues CGI-Objekt und hole das vorhandene Cookie
#mit der Session-ID
my $cgi = new CGI;

#Stelle das alte zugehoerige Session-Objekt zu dem aktuellen
#User her
my $session = CGI::Session->new($cgi);

#Hole die (eventuell) uebergebenen Daten und speicher diese ab

if($cgi->param('Level1') ne '')
{
	$session->param('ShowPage_Level1',$cgi->param('Level1'));
}

if($cgi->param('Level2') ne '')
{
	$session->param('ShowPage_Level2',$cgi->param('Level2'));
}

if($cgi->param('Level3') ne '')
{
	$session->param('ShowPage_Level3',$cgi->param('Level3'));
}

if($cgi->param('input_Login') ne '')
{
	$session->param('UserIdent',$cgi->param('input_Login'));
}

if($cgi->param('input_Password') ne '')
{
	$session->param('UserPassword',$cgi->param('input_Password'));
}

if($cgi->param('input_Vorname') ne '')
{
	$session->param('RegistrationVorname',$cgi->param('input_Vorname'));
}

if($cgi->param('input_Nachname') ne '')
{
	$session->param('RegistrationNachname',$cgi->param('input_Nachname'));
}

if($cgi->param('input_Email') ne '')
{
	$session->param('RegistrationEmail',$cgi->param('input_Email'));
}

if($cgi->param('input_Password1') ne '')
{
	$session->param('RegistrationPassword1',$cgi->param('input_Password1'));
}

if($cgi->param('input_Password2') ne '')
{
	$session->param('RegistrationPassword2',$cgi->param('input_Password2'));
}

$session->flush();

#Leite auf Root um
print $cgi->header();
print $cgi->h1( 'Daten' );
print $cgi->h1( $session->param('ShowPage_Level1'));
print $cgi->h1( $session->param('ShowPage_Level2'));
print $cgi->h1( $session->param('ShowPage_Level3'));

print $cgi->meta({-http_equiv => 'REFRESH', -content => '2; /cgi-bin/rocket/Rocket.cgi'});