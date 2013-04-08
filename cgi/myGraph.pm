#!perl -w
########################################
#Author: Matthias Nagel                #
#Date: 	 08.04.2013                    #
########################################
#Description: Dieses Script erzeugt anhand ihm �bergebener Daten Graphen

package myGraph;

use strict;
use CGI ':standard';
use GD::Graph::pie;
use CGI::Carp qw(fatalsToBrowser);
use db_access 'get_countTicketbyStatus';
use feature qw {switch};



our @EXPORT_OK = qw(print_Statistik_TicketStatus);

sub print_Statistik_TicketStatus {
	print STDERR "Processing Statistik_TicketStatus ...\n";
	my @data = (['Neu','in Bearbeitung','Geschlossen'],
				[db_access::get_countTicketbyStatus('Neu'), db_access::get_countTicketbyStatus('in Bearbeitung'), db_access::get_countTicketbyStatus('Geschlossen')]);
	
	my $mygraph = GD::Graph::pie->new(400,400);
	$mygraph->set(
		title => '�bersicht Ticket-Status',
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
	my $chart = shift or die "Ben�tige Chart!";
	my $name = shift or die "Ben�tige Name!";
	local(*OUT);
	
	my $ext = $chart->export_format;
	my $pfad = "";
	my $filename = $name.".".$ext;
	
	#open(OUT, ">../../img/Statistik/$name.$ext") or die "Kann $name.$ext nicht �ffnen: $!";
	open(OUT, ">../../htdocs/rocket/$filename") or die "Kann $filename nicht �ffnen: $!";
	
	binmode OUT;
	print OUT $chart->gd->$ext();
	close OUT;
	
	return $filename;
}