#!perl -w
#db_access.pm
#stellt Zugang und Zugriffe auf die Datenbank her und zur Verf�gung

package db_access;

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use Config::Tiny;			#Modul, um DB-Config aus ini-File auszulesen
use feature qw {switch};

sub db_connect { 
	#Aufruf: db_connect()
	#stellt Verbindung zur Datenbank her
	#R�ckgabe: Datenbank-Handle
	
	#L�d Zugangsdaten aus der INI-Datei
	my $configfile = Config::Tiny->read( '../sql/db.ini' );
	my $host = $configfile->{db}->{host};
	my $db = $configfile->{db}->{db};
	my $user = $configfile->{db}->{user};
	my $password = $configfile->{db}->{password};
	
	#Stellt die Verbindung her und speichter dies ins Handle
	my $dbhandle = DBI->connect("DBI:mysql:".$db.":".$host,$user,$password) or die $DBI::errstr;
	return $dbhandle;
}

sub db_disconnect {
	#Aufruf: db_disconnect( Datenbank-Handle )
	#trennt die Verbindung zur Datenbank
	my $dbhandle = shift;
	$dbhandle->disconnect() or warn $dbhandle->errstr;
}

sub valid_Login { 
	#Aufruf: valid_Login( Email, Passwort )
	#pr�ft, ob der Login erfolgreich war, also Username&Passwort richtig sind
	#R�ckgabe: boolschen Wert, ob Validierung erfolgreich
	my($Username,$Password) = @_;
	
	my $db = db_connect(); #�bergibt DB-Handle
	my $command = $db->prepare("SELECT sql_valid_Login(\'". $Username. "\',\'". $Password . "\') AS valid;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen des boolschen Wertes der SQL-Abfrage
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub exist_User {
	#Aufruf: exist_User ( Email )
	#�berpr�ft, ob der Benutzer (Email) existiert bzw in der User-Tabelle vorhanden ist
	#R�ckgabe: boolschen Wert, ob User existiert
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
	#Aufruf: insert_User ( Name, Vorname, Email, Passwort )
	#f�r die Registrierung neuer Benutzer, legt User in der DB an
	#R�ckgabe: boolschen Wert, ob Anlegen erfolgreich
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

sub set_Hash { 
	#Aufruf: set_Hash( Email, Hash )
	#f�r den Login, Hash wird dem ausgew�hlten User beigef�gt
	#R�ckgabe: boolschen Wert, ob Setzen des Hashs erfolgreich
	my($Username,$Hash) = @_;
	my $db = db_connect();
	my $sql = "UPDATE user SET SESSION_ID=\'".$Hash."\' WHERE Email=\'".$Username."\';";
	my $command = $db->prepare($sql);;
	$command->execute();	
	$command->finish();
	$db = db_disconnect($db);
	my $getHash = get_Hash($Username); #Proble, ob DB-Hash gleich dem �bergebenen Hash
	my $result = 0;
	($result=1) if($Hash eq $getHash);
	return $result;	
}

sub del_Hash { 
	#Aufruf: del_Hash( Email )
	#l�scht den Hash des �bergebenen Users
	#R�ckgabe: boolschen Wert, ob l�schen des Hashes erfolgreich
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

sub get_Hash {
	#Aufruf: get_Hash( Email )
	#ruft den Hash des �bergebenen Users ab
	#R�ckgabe: SESSION_ID aus der user Tabelle der DB
	my($Username) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT SESSION_ID FROM user WHERE Email=\'". $Username . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub create_Ticket {
	#Aufruf: create_Ticket( Email, Betreff, Nachrichtentext, Auswahlkriterium, Priorit�t)
	#Legt ein neues Ticket und eine dazu geh�rende Message in der Datenbank an
	#R�ckgabe: boolscher Wert, ob erstellen des Tickets und der Message erfolgreich
	
	my($Username,$Betreff,$Message,$AID,$PID) = @_;
	
	#Abrufen der IP und des Betriebssystems aus einem CGI-Objekt und aus der Systemumgebung
	my $cgi = new CGI;
	my $myIP=$cgi->remote_host();
	my $myOS = $^O;
	
	my $db = db_connect();
	my $sql = "CALL sql_create_Ticket(\'".$Username."\',\'".$Betreff."\',\'".$Message."\',\'".$AID."\',\'".$PID."\',\'".$myIP."\',\'".$myOS."\');";
	my $command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub answer_Ticket {
	#Author: Thomas Dorsch, Date 03.04.2013
	#Aufruf answer_Ticket ( Email, TicketID, Nachrichtentext)
	#R�ckgabe: boolscher Wert, ob Antwort erfolgreich in die DB eingetragen und mit Ticket verkn�pft wurde
	
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
	#Aufruf get_AccessRights ( Email )
	#liefert zu �bergebenen Benutzer die AccessRights (Zugriffsrechte)
	#R�ckgabe: Name des Zugriffsrecht ( M�glichkeiten: "User", "Mitarbeiter", "Administrator" )
	my($Username) = @_;
	my $db = db_connect(); #�bergibt DB-Handle
	my $command = $db->prepare("CALL sql_get_AccessRights(\'". $Username. "\');");
	$command->execute();	
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array(); #abrufen der R�ckgabe
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_Tickets {
	#Author: Thomas Dorsch	Date: 30.03.2013
	#Aufruf: get_Tickets(Email)
	#liefert alle Tickets die ein bestimmter User erstellt hat
	#R�ckgabe: Referenz auf Array mit Ticketdaten
	
	my($Username) = @_;
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_Tickets(\'". $Username. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_Messages_from_Ticket {
	#Author: Thomas Dorsch Date: 01.04.2013
	#Aufruf: get_Messages_from_Ticket( Email, TicketID )
	#liefert alle Messages die zu einem Ticket gehoeren zurueck
	#R�ckgabe: Referenz auf Array mit Nachrichtendaten
	
	my($UserIdent, $TicketID) = @_;	
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_Messages_from_Ticket(\'". $TicketID. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_TicketsbyStatus {
	#Aufruf: get_TicketsbyStatus(EMail,Status);
	#liefert Tickets mit gew�nschtem Status, zu denen der Mitarbeiter(Email) berechtigt ist, diese zu sehen
	#R�ckgabe: Referenz auf Array mit Ticketdaten
	
	my($Username,$Status) = @_;
	my $db = db_connect();
	my $sqlcommand = "CALL sql_get_TicketsbyStatus(\'". $Username. "\',\'". $Status. "\');";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_countTicketbyStatus {
	#Aufruf get_countTicketbyStatus ( Ticketstatus )
	#f�r Graphen in Statistik; liefert Anzahl der Tickets mit �bergebenem Status
	#R�ckgabe: Anzahl der Tickets mit diesem Status
	
	my($Status) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT COUNT(*) FROM ticket WHERE Status=\'". $Status . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;	
}

sub get_MA_Level { 
	#Aufruf: get_MA_Level( Email )
	#liefert den INT-Wert aus der Spalte Level des entsprechenden Mitarbeiters zur�ck
	#R�ckgabe: Level des Mitarbeiters (INT-Wert)
	
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
	#Aufruf: get_TicketStatus( TicketID )
	#liefert den Status zu �bergebener TicketID zur�ck. 
	#R�ckgabe: Status (M�gliche Werte: "Neu", "Geschlossen", "In Bearbeitung");
	
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
	#Aufruf: get_TicketPrioritaet( TicketID )
	#liefert die Priorit�t zu �bergebenem Ticket
	#R�ckgabe: Priorit�t (INT-Wert)
	
	my($Ticket_ID) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT Prioritaet_ID FROM ticket WHERE Ticket_ID =\'". $Ticket_ID . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;
}

sub assume_Ticket { 
	#Aufruf: assume_Ticket( Email, TicketID )
	#Ticket wird in der DB von User (Email) in Bearbeitung gesetzt
	#R�ckgabe: boolscher Wert, ob Operation erfolgreich( 1 bei TRUE, 0 bei FALSE )
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

sub forward_Ticket { 
	#Aufruf: forward_Ticket( Email, TicketID )
	#Ticket wird in der DB von User (Email) weitergeleitet
	#R�ckgabe: boolscher Wert, ob Operation erfolgreich( 1 bei TRUE, 0 bei FALSE )
	
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

sub release_Ticket { 
	#Aufruf: release_Ticket( Email, TicketID )
	#Ticket wird in der DB von User (Email) freigegeben
	#R�ckgabe: boolscher Wert, ob Operation erfolgreich( 1 bei TRUE, 0 bei FALSE )
	
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

sub close_Ticket {
	#Aufruf: close_Ticket( Email, TicketID )
	#Ticket wird in der DB von User (Email) auf "Geschlossen" gesetzt
	#R�ckgabe: boolscher Wert, ob Operation erfolgreich( 1 bei TRUE, 0 bei FALSE )
	
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
sub is_Authorized { 
	#Aufruf: is_Authorized( Email, TicketID )
	#pr�ft, ob Benutzer berechtigt ist, Operationen auf das Ticket auszuf�hren
	#R�ckgabe: boolscher Wert, ob authoriziert oder nicht
	
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

sub get_Auswahlkriterien {
	#Aufruf: get_Auswahlkriterien( TicketID )
	#liefert Priorit�t des Tickets
	#R�ckgabe: Priorit�t (INT-Wert)
	my($TicketID) = @_;
	my $db = db_connect();
	my $command = $db->prepare("SELECT Prioritaet_ID FROM ticket WHERE Ticket_ID =\'". $TicketID . "\';");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$command->finish();
	$db = db_disconnect($db);
	return $result;
}

sub get_DropDownValues { 
	#AUTHOR Thomas Dorsch DATE 09.04.13
	#Aufruf: get_DropDownValues( Tabellenname )
	#liefert eine gehashte Liste mit DropDown-Values zur�ck welche dann von einem anderen
	#Tabelle muss folgenderweise aufgebaut sein damit es funktioniert: TABLE_INDEX | VALUE
	#R�ckgabe: Referenz auf Array f�r Dropdown
	
	my $tablename = $_[0];
	my $db = db_connect();
	my $sqlcommand = "SELECT * FROM $tablename;";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;
}

sub change_Password { 
	#AUTHOR Thomas Dorsch DATE 09.04.13
	#Aufruf: change_Password( Email, neues gehashtes Passwort )
	#�ndert den Passwort-Hash des �bergebenen Users
	#R�ckgabe: boolscher Wert, ob �nderung erfolgreich war

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

sub deleteAccount { 
	#AUTHOR Thomas Dorsch 10.04.13
	#Aufruf: deleteAccount( Email )
	#l�scht den mitgelieferten Account aus der Datenbank, unterscheidet dabei aber AccessRights
	#R�ckgabe: boolscher Wert, ob L�sung erfolgreich
	
	my $User = $_[0];
	#Zuerst wird gepr�ft, ob Admin/Mitarbeiter/User, danach entsprechend die L�schung durchgef�hrt
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

sub changeEmail { 
	#AUTHOR Thomas Dorsch 16.04.13
	#Aufruf: changeEmail( alte Email (UserIDent), neue Email-Adresse )
	#�ndert die Email-Adresse des Benutzers
	#R�ckgabe: boolscher Wert, ob �nderung erfolgreich
	
	my $User = $_[0];
	my $newEmail = $_[1];		
	my $db = db_connect();
	$sql = "CALL sql_change_Email(\'".$User."\',\'".$newEmail."\');";
	$command = $db->prepare($sql);
	$command->execute();
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	$result = $command->fetchrow_array();
	return $result;
}

sub get_User {
	#Aufruf: get_User();
	#liefert alle Benutzer zur�ck
	#R�ckgabe: Referenz auf Array mit Usern
	
	my $db = db_connect();
	my $sqlcommand = "SELECT * FROM user";
	my $ref_array = $db->selectall_arrayref($sqlcommand);
	$db = db_disconnect($db);
	return $ref_array;	
}

sub get_UserData {
	#Aufruf: get_UserData( User_ID );
	#liefert alle Benutzerdaten zu der �bergebenen User_ID
	#R�ckgabe: Array mit User_ID, Name, Vorname, Email des ausgew�hlten Benutzers
	
	my($User_ID) = @_;
	my $db = db_connect();
	my $sqlcommand = "SELECT User_ID,Name,Vorname,Email FROM user WHERE User_ID=\'".$User_ID."\'";
	my @array = $db->selectrow_array($sqlcommand);
	$db = db_disconnect($db);
	return @array;	
}

sub get_Email {
	#Aufruf: get_Email( User_ID )
	#sucht zur �bergebenen User_ID die Email-Adresse
	#R�ckgabe: Email-Adresse
	
	my $User = $_[0];
	my $db = db_connect();
	$command = $db->prepare("SELECT Email FROM user WHERE User_ID=\'". $User ."\'");
	$command->execute();	
	$result = $command->fetchrow_array();
	$db = db_disconnect($db);
	return $result;
}		

sub update_User {
	#Aufruf: update_User( User_ID, neuer Name, neuer Vorname, neue Email )
	#�ndert die Benutzerdaten des �bergebenen Users ab
	#R�ckgabe: boolschen Wert, ob �nderung erfolgreich
	
	my ($User_ID,$Name_Neu,$Vorname_Neu, $Email_Neu) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_update_User(\'". $User_ID ."\',\'". $Name_Neu ."\',\'". $Vorname_Neu ."\',\'". $Email_Neu ."\');";
	my $command = $db->prepare($sql);
	$command->execute();	
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$db = db_disconnect($db);
	return $result;
}
sub update_AccessRights {
	#Aufruf: update_AccessRights( User_ID, alte Rechte, neue Rechte, Email, AbteilungsID, Level )
	#�ndert die AccessRights sowie Daten in der Tabelle mitarbeiter f�r den �bergebenen User ab
	#R�ckgabe: boolscher Wert, ob �nderung erfolgreich
	
	my ($User_ID,$alt,$neu, $Email_Neu,$Abteilung,$Level) = @_;
	my $db = db_connect();
	my $sql = "CALL sql_update_AccessRights(\'". $User_ID ."\',\'". $alt ."\',\'". $neu ."\',\'". $Abteilung ."\',\'". $Level ."\');";
	my $command = $db->prepare($sql);
	$command->execute();	
	$command = $db->prepare("SELECT \@ret;");
	$command->execute();	
	my $result = $command->fetchrow_array();
	$db = db_disconnect($db);
	return $result;
}
1;
