#!perl -w
#getinfo.pm
#stellt Zugang und Zugriffe auf die Datenbank her und zur Verfügung


package getinfo;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_IP);

sub get_IP() {
my $name = (gethostbyname ("localhost"))[0];
my $addr = (gethostbyname ($name))[4];
#print "$name\n";
my $meineip= join ('.', unpack ("C4", $addr));
return "$meineip";
}