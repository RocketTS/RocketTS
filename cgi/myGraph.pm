#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 08.04.2013                    #
########################################
#Description: Dieses Script erzeugt anhand ihm übergebener Daten Graphen für die Mitarbeiter-Statistik
#Anschließend wird das erzeugte Bild im htdocs-Ordner des Webpfads abgespeichert, da CGI scheinbar Probleme mit dem Bilder anzeigen hat


package myGraph;

use strict;
use CGI ':standard';
use GD::Graph::pie;
use CGI::Carp qw(fatalsToBrowser);
use db_access;


sub print_Statistik_TicketStatus {
	#Aufruf: von MitarbeiterContent::print_Statistik()
	#generiert aus der Datenbank gelieferten Werten eine Grafik
	#Rückgabe: gibt den von save_chart() erzeugten Bildnamen zurück
	print STDERR "Processing Statistik_TicketStatus ...\n";
	my @data = (['Neu','in Bearbeitung','Geschlossen'],
				[db_access::get_countTicketbyStatus('Neu'), db_access::get_countTicketbyStatus('in Bearbeitung'), db_access::get_countTicketbyStatus('Geschlossen')]);
	
	my $mygraph = GD::Graph::pie->new(400,400);
	$mygraph->set(
		title => 'Übersicht Ticket-Status',
		start_angle => 90,
		'3d' => 0,
		suppress_angle => 5,
		dclrs => [ qw(red orange green)],
		transparent => 1,) or warn $mygraph->error;			
	$mygraph->set_value_font(GD::gdMediumBoldFont);
	
	$mygraph->plot(\@data);
	return save_chart($mygraph, 'Statistik_TicketStatus');
}

sub save_chart {
	#Aufruf: save_chart ( erzeugte Grafik, gewünschter Name )
	#Funktion speichert die übergebene Grafik in eine Datei
	#Rückgabe: gibt Dateinamen zurück 
	
	my $chart = shift or die "Benötige Chart!";
	my $name = shift or die "Benötige Name!";
	local(*OUT);
	
	my $ext = $chart->export_format;
	my $pfad = "";
	my $filename = $name.".".$ext;
	
	open(OUT, ">../../htdocs/rocket/$filename") or die "Kann $filename nicht öffnen: $!";
	
	binmode OUT;
	print OUT $chart->gd->$ext();
	close OUT;
	
	return $filename;
}
1;