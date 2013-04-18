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

if($cgi->param('input_Betreff') ne '')
{
	$session->param('UserMessageTopic',$cgi->param('input_Betreff'));
}

if($cgi->param('input_Message') ne '')
{
	$session->param('UserMessage',$cgi->param('input_Message'));
}

if($cgi->param('input_specificTicket') ne '')
{
	$session->param('specificTicket',$cgi->param('input_specificTicket'));
}

if($cgi->param('input_Categorie') ne '')
{
	$session->param('TicketCategorie',$cgi->param('input_Categorie'));
}

if($cgi->param('input_Password_new1') ne '')
{
	$session->param('newPassword1',$cgi->param('input_Password_new1'));
}

if($cgi->param('input_Password_new2') ne '')
{
	$session->param('newPassword2',$cgi->param('input_Password_new2'));
}

if($cgi->param('input_Email_new') ne '')
{
	$session->param('newEmail',$cgi->param('input_Email_new'));
}

if($cgi->param('input_specificUser') ne '')
{
	$session->param('specificUser',$cgi->param('input_specificUser'));
}

if($cgi->param('input_Name_new') ne '')
{
	$session->param('Name_new',$cgi->param('input_Name_new'));
}
if($cgi->param('input_Vorname_new') ne '')
{
	$session->param('Vorname_new',$cgi->param('input_Vorname_new'));
}
if($cgi->param('input_Email_new') ne '')
{
	$session->param('Email_new',$cgi->param('input_Email_new'));
}
if($cgi->param('input_AccessRights_new') ne '')
{
	$session->param('AccessRights_new',$cgi->param('input_AccessRights_new'));
}
if($cgi->param('input_Level_new') ne '')
{
	$session->param('Level_new',$cgi->param('input_Level_new'));
}
if($cgi->param('input_Abteilung_new') ne '')
{
	$session->param('Abteilung_new',$cgi->param('input_Abteilung_new'));
}


$session->flush();

#Leite auf Root um
print $cgi->header();

#Folgende Ausgaben waren für das debuggen hilfreich und sind in der Endfassung auskommentiert
#print $cgi->h1( 'Daten' );
#
#print $cgi->h1( $session->param('RegistrationVorname'));
#print $cgi->h1( $session->param('RegistrationNachname'));
#print $cgi->h1( $session->param('RegistrationEmail'));
#print $cgi->h1( $session->param('RegistrationPassword1'));
#print $cgi->h1( $session->param('RegistrationPassword2'));
#
#print $cgi->h1( $session->param('ShowPage_Level1'));
#print $cgi->h1( $session->param('ShowPage_Level2'));
#print $cgi->h1( $session->param('ShowPage_Level3'));
#
#print $cgi->h1( $session->param('specificTicket'));
#

print $cgi->meta({-http_equiv => 'REFRESH', -content => '0; /cgi-bin/rocket/Rocket.cgi'});