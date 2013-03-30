#!perl -w
#db_access.pm
#stellt Zugang und Zugriffe auf die Datenbank her und zur Verfügung

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

package db_access;
use DBI;
use Config::Tiny;			#Modul, um DB-Config aus ini-File auszulesen
use getinfo 'get_IP';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(valid_Login exist_User insert_User get_Hash del_Hash set_Hash db_connect db_disconnect insert_Ticket create_Ticket get_AccessRights get_Tickets);

sub db_connect { 
	#Läd Zugangsdaten aus der INI-Datei
	my $configfile = Config::Tiny->read( '../sql/db.ini' );
	my $host = $configfile->{db}->{host};
	my $db = $configfile->{db}->{db};
	my $user = $configfile->{db}->{user};
	my $password = $configfile->{db}->{password};
	
	my $dbhandle = DBI->connect("DBI:mysql:".$db.":".$host,$user,$password) or die $DBI::errstr;
	return $dbhandle;
}

sub db_disconnect {
	my $dbhandle = shift;
	$dbhandle->disconnect() or warn $dbhandle->errstr;
}

sub db_select {
	my $dbhandle = shift;
	my $sql = $_[0];
	my $select = $dbhandle->prepare($sql);
	return $select;
}

sub valid_Login { #Aufruf valid_Login($Username,$Password)
	my($Username,$Password) = @_;
	
	my $db = db_connect(); #übergibt DB-Handle
	my $command = $db->prepare("SELECT sql_valid_Login(\'". $Username. "\',\'". $Password . "\') AS valid;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub exist_User {
	my ($Username) = @_;
	my $db = db_connect();
	my $sql = "SELECT sql_exist_User(\'".$Username."\');";
	my $command = $db->prepare($sql);
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
	
}

sub insert_User {
	my ($iName,$iVorname,$iEmail,$iPasswort) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_insert_User(\'".$iName."\',\'".$iVorname."\',\'".$iEmail."\',\'".$iPasswort."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
	
} 

sub set_Hash {  #liefert bool 
	my($Username,$Hash) = @_;
	my $db = db_connect();
	my $sql = "UPDATE user SET SESSION_ID=\'".$Hash."\' WHERE Email=\'".$Username."\';";
	my $command = $db->prepare($sql);;
	$command->execute();	
	$command->finish();
	$db = db_disconnect($db);
	my $getHash = get_Hash($Username);
	my $result = 0;
	($result=1) if($Hash eq $getHash);
	return $result;	
}

sub del_Hash {  #liefert bool 
	my($Username) = @_;
	my $db = db_connect();
	my $sql = "UPDATE user SET SESSION_ID=\'\' WHERE Email=\'".$Username."\';";
	my $command = $db->prepare($sql);;
	$command->execute();	
	$command->finish();
	$db = db_disconnect($db);
	my $getHash = get_Hash($Username);
	my $result = 0;
	($result=1) if("" eq $getHash);
	return $result;	
}

sub get_Hash {  #liefert hash
	my($Username) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT SESSION_ID FROM user WHERE Email=\'". $Username . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub insert_Ticket {
	#(p_Email varchar(40), p_Betreff varchar(40), p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
	my($Username,$Betreff,$AID,$PID) = @_;
	my $myIP=$ENV{REMOTE_ADDR};	
		($myIP=get_IP()) if ($myIP eq "::1");
	my $myOS=$^O;
	
	my $db = db_connect();
	my $sql = "CALL sql_insert_Ticket(\'".$Username."\',\'".$Betreff."\',\'".$AID."\',\'".$PID."\',\'".$myIP."\',\'".$myOS."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;"); #Abfrage des boolschen Rückgabewerts
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub create_Ticket {
	#(p_Email varchar(40), p_Betreff varchar(40), p_Message text, p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
	my($Username,$Betreff,$Message,$AID,$PID) = @_;
	my $myIP=get_IP();
	my $myOS=$^O;
	my $db = db_connect();
	my $sql = "CALL sql_create_Ticket(\'".$Username."\',\'".$Betreff."\',\'".$Message."\',\'".$AID."\',\'".$PID."\',\'".$myIP."\',\'".$myOS."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_AccessRights {
	my($Username) = @_;
	my $db = db_connect(); #übergibt DB-Handle
	my $command = $db->prepare("CALL sql_get_AccessRights(\'". $Username. "\');");
	$command->execute();	
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen der Rückgabe
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_Tickets {#Author: Thomas Dorsch	Date: 30.03.2013
	my($Username) = @_;
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_Tickets(\'". $Username. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}