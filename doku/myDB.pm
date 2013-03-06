#!perl
#17.01.2013
#Modul DB.pm soll folgende Fumktionen bereitstellen
#db_connect -> Rückgabe DB-Handle
#db_disconnect
#db_select -> Rückgabe Statementhandle

package myDB;
use DBI;
use Exporter;

our @ISA = qw(Exporter);

# alle automatisch exportierten Symbole
our @EXPORT_OK = qw(db_connect db_disconnect db_select);


#Aufruf: db_connect (user, passwort, datenbank, host)
sub db_connect{
	my ($user, $pass, $db, $host) = @_;
#	my $user = $_[0];
#	my $pass = $_[1];
#	my $db = $_[2];
#	my $host = $_[3];
	my $driver = "DBI:mysql:".$db.":".$host;
	
	my $dbhandle = DBI->connect($driver,$user,$pass) or die $DBI::errstr;
	return $dbhandle;
	
}

#Aufruf: db_disconnect (db_handle)

sub db_disconnect{
	$_[0]->disconnect;	
}

#Aufruf: db_select ( db_handle, Befehl)
sub db_select{
	my $Command = $_[1];
	my $sth = $_[0]->prepare($Command);
	return $sth;
}