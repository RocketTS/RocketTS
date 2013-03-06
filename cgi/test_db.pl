#!perl

use db_access 'db_connect','db_select','db_disconnect';


my $db = db_connect();
my $command = db_select($db,"SELECT * FROM user");
$command->execute();

while(my @ausgabe = $command->fetchrow_array()){
	print "Datensatz: @ausgabe \n";
}

$db = db_disconnect($db);