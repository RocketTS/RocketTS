#!perl -w
#db_access.pm
#stellt Zugang und Zugriffe auf die Datenbank her und zur Verfügung

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

package db_access;
use DBI;
use Config::Tiny;			#Modul, um DB-Config aus ini-File auszulesen
use Exporter;
use feature qw {switch};
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(valid_Login exist_User insert_User get_Hash del_Hash set_Hash db_connect db_disconnect insert_Ticket create_Ticket 
					answer_Ticket get_AccessRights get_Tickets get_Messages_from_Ticket get_newTickets get_TicketsbyStatus 
					get_countTicketbyStatus get_MA_Level get_TicketStatus get_TicketPrioritaet is_Authorized assume_Ticket forward_Ticket
					release_Ticket close_Ticket);

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
	#my $myIP=$ENV{REMOTE_ADDR};	
	#	($myIP=get_IP()) if ($myIP eq "::1");
	my $cgi = new CGI;
	my $myIP=$cgi->remote_host();
	my $myOS = $^O;
	
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

sub answer_Ticket {#Author: Thomas Dorsch, Date 03.04.2013
	#(p_Email varchar(40), p_TicketID INT, p_Message text, p_IP varchar(20), p_OS varchar(20))
	my($Username,$TicketID,$Message) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_answer_Ticket(\'".$Username."\',\'".$TicketID."\',\'".$Message."\');";
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
	#liefert alle Tickets die ein bestimmter User erstellt hat
	my($Username) = @_;
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_Tickets(\'". $Username. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_Messages_from_Ticket {#Author: Thomas Dorsch Date: 01.04.2013
	#liefert alle Messages die zu einem Ticket gehoeren zurueck
	my($UserIdent, $TicketID) = @_;
	
	#Pruefe zuerst ob der User auf die geforderten Messages vom Ticket zugreifen darf
	#Kurz: Ist er der Eigentuemer?
	#MUSS NOCH GEMACHT WERDEN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_Messages_from_Ticket(\'". $TicketID. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
	
}

sub get_newTickets { #müll?
	#liefert alle Tickets die ein bestimmter User erstellt hat
	#my($Username) = @_;
	my $db = db_connect();
	my $sqlcommand = "SELECT * from view_newTickets;";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_TicketsbyStatus {
	#Aufruf: get_TicketsbyStatus(EMail,Status);
	#liefert Tickets zu Usernamen mit gewünschtem Status
	my($Username,$Status) = @_;
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_TicketsbyStatus(\'". $Username. "\',\'". $Status. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_countTicketbyStatus {
	my($Status) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT COUNT(*) FROM ticket WHERE Status=\'". $Status . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_MA_Level { #liefert den INT-Wert aus der Spalte Level des entsprechenden Mitarbeiters zurück
	my($Username) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT Level FROM mitarbeiter M, user U WHERE M.User_ID=U.User_ID AND U.Email =\'". $Username . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_TicketStatus {
	my($Ticket_ID) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT Status FROM ticket WHERE Ticket_ID =\'". $Ticket_ID . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;
}

sub get_TicketPrioritaet {
	my($Ticket_ID) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT Prioritaet_ID FROM ticket WHERE Ticket_ID =\'". $Ticket_ID . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;
}

sub assume_Ticket { #liefert 1 bei TRUE, 0 bei FALSE
	my($Username,$Ticket_ID) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_assume_Ticket(\'".$Username."\',\'".$Ticket_ID."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub forward_Ticket { #liefert 1 bei TRUE, 0 bei FALSE
	my($Username,$Ticket_ID) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_forward_Ticket(\'".$Username."\',\'".$Ticket_ID."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub release_Ticket { #liefert 1 bei TRUE, 0 bei FALSE
	my($Username,$Ticket_ID) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_release_Ticket(\'".$Username."\',\'".$Ticket_ID."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub close_Ticket { #liefert 1 bei TRUE, 0 bei FALSE
	my($Username,$Ticket_ID) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_close_Ticket(\'".$Username."\',\'".$Ticket_ID."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}
sub is_Authorized { #liefert 1 bei TRUE, 0 bei FALSE
	my($Username,$Ticket_ID) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_is_Authorized(\'".$Username."\',\'".$Ticket_ID."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_DropDownValues { #AUTHOR Thomas Dorsch DATE 09.04.13
	#Modul liefert eine gehashte Liste mit DropDown-Values zurück welche dann von einem anderen
	#Modul genutzt werden kann um diese auf der Website auszugeben
	#Übergabeparameter: Tabellenname, in dem sich die Werte befinden
	#Tabelle muss folgenderweise aufgebaut sein damit es funktioniert
	#TABLE_INDEX VALUE
	my $tablename = $_[0];
	
	my $db = db_connect();
	my $sqlcommand = "SELECT * FROM $tablename;";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;
}

sub change_Password { #AUTHOR Thomas Dorsch DATE 09.04.13
	#Modul ändert das den Hash des Passwortes zu dem mitglieferten UserIdent
	#Es gibt nen boolschen Rückgabewert, ob das Ganze erfolgreich war
	#Übergabeparameter: 1. UserIdent
	#					2. gehashte Passwort
	my ($UserIdent,$hashed_Password) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_change_Password(\'".$UserIdent."\',\'".$hashed_Password."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub deleteAccount { #AUTHOR Thomas Dorsch 10.04.13
	#Subroutine löscht den mitgelieferten Account aus der Datenbank
	#Übergabeparameter: 1: UserIdent
	my $User = $_[0];
	#Zuerst wird nachgeschaut ob es sich um einen Admin/Mitarbeiter/User handelt
	#Je nachdem was vorliegt muss die Löschung anders abgehandelt werden
	my $typ = db_access::get_AccessRights($User);
	my $db = db_connect();
	my $result;
	my $command;
	my $sql;
	given ($typ)
		{
			when( 'Administrator' )	{$sql = "CALL sql_del_Administrator(\'".$User."\');";
									 $command = $db->prepare($sql);
								  	 $command->execute();
									 $command = $db->prepare("SELECT \@ret;");
									 $command->execute();	
									 $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
									 }
									 
			when( 'Mitarbeiter' )	{$sql = "CALL sql_del_Mitarbeiter(\'".$User."\');";
									 $command = $db->prepare($sql);
								  	 $command->execute();
									 $command = $db->prepare("SELECT \@ret;");
									 $command->execute();	
									 $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
									 }
									 
			when( 'User' )			{$sql = "CALL sql_del_User(\'".$User."\');";
									 $command = $db->prepare($sql);
								  	 $command->execute();
									 $command = $db->prepare("SELECT \@ret;");
									 $command->execute();	
									 $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
									 }
		}
	return $result;
}
		
	
