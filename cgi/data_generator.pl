#!perl
#Name: Data Generator
#Description: Erzeugt Dummy-Einträge in der Datenbank

use db_access 'db_connect','db_disconnect';
my @user;
my @os = qw(Windows Linux MacOSX);
my @betreff = qw(Fehlermeldung Hinweis Anmerkung);

#print $os[int(rand(@os))];

my $db = db_connect(); #übergibt DB-Handle
my $command = $db->prepare("SELECT Name FROM user;");
$command->execute();

while (my $u = $command->fetchrow_array()){
	#print $u;
	push @user,$u;
	
}

$command->finish();
$db = db_disconnect($db);

print $user[int(rand(@user))];
print REMOTE_HOST;

