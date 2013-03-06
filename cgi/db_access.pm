#!perl -w
#db_access.pm
#stellt Zugang und Zugriffe auf die Datenbank her und zur Verfügung

package db_access;
use DBI;
use Config::Tiny;			#Modul, um DB-Config aus ini-File auszulesen
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(db_connect db_disconnect db_select);

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

sub db_select { # db_select(Handle,Befehl);
	my $dbhandle = shift;
	my $sql = $_[0];
	my $select = $dbhandle->prepare($sql);
	return $select;
}