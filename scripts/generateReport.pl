#!/usr/bin/env perl
use warnings;
use strict;
my $usage = "perl generateReport.pl <genomeFA> <summaryFile> <loc> <version>
";

if (@ARGV<4){
    die $usage;
}

my $genome = $ARGV[0];
my $summary = $ARGV[1];
my $loc = $ARGV[2];
my $version = $ARGV[3];

my @a = split("/", $genome);
my $gname = $a[@a-1];
my $rdir = "$loc/VODKA_report.$gname";
unless (-d "$rdir"){
    `mkdir -p $rdir`;
}
unless (-d "$rdir/dvg/fasta"){
    `mkdir -p $rdir/dvg/fasta`;
}
unless (-d "$rdir/dvg/logo"){
    `mkdir -p $rdir/dvg/logo`;
}
my @sx = split("/", $summary);
my $sum_name = $sx[@sx-1];
if (-e "$summary"){
    `cp $summary $rdir`;
}
else{
    die "ERROR: summary file $summary does not exist\n";
}
$sum_name =~ /$gname.(.*)_RESULTS.filtered.SUMMARY.txt/;
my $str_size = $1;

my $results = $summary;
$results =~ s/.SUMMARY.txt$/.txt/;
my $r_name = $sum_name;
$r_name =~ s/.SUMMARY.txt$/.txt/;
if (-e $results){
    `cp $results $rdir/`;
}
else{
    die "ERROR: result file $results does not exist\n";
}

my $style = "

body {
/*background-color:#EFFBFB;*/
font-family: helvetica;
color:#333;
margin:0;
padding:0;
}

.hidden{
  display: none;
  visibility: hidden;
}

#wrapper {
width:auto;
margin:0 auto;
border-left:1px solid #ccc;
border-right:1px solid #ccc;
}

#tab { 
display:inline-block; 
margin-left: 40px; }

div.header {
background-color: #EEEB95;
border:0;
margin:0;
padding: 0.5em;
font-size: 175%;
font-weight: bold;
color: #56573C;
position:fixed;
width:100%;
z-index:2;
}

#header_title {
display:block;
text-align:center;
vertical-align: middle;
}

div.main {
display:block;
position:absolute;
overflow:auto;
height:auto;
width:auto;
top:2.3em;
bottom:2.3em;
left:0;
right:0;
padding:1em;
  background-color: white;
  z-index:1;
}

#sidebar {
width:200px;
float:right;
margin-bottom:25px;
}

#sidebar a {
text-decoration:none;
}

#sidebar li {
list-style:none;
}

div.footer {
background-color:#EEEB95;
border:0;
margin:0;
padding:0.3em;
height: 1em;
overflow:hidden;
font-size: 100%;
font-weight:bold;
color: #56573C;
position:fixed;
bottom:0;
width:100%;
z-index:2;
text-align:right;
right:1.5;
}

table{
    border-collapse:collapse;
  width: 100%;
    text-align:left;
}


table, td, th {
  border: 1px solid #2C594C;
    padding: 5px;
}

th {
    background-color: #3F7FBF;
  color: #f8f8f8;
}

a:link    {
  /* Applies to all unvisited links */
      text-decoration:  none;
  font-weight:      bold;
 color:            blue;
} 
a:visited {
  /* Applies to all visited links */
  text-decoration:  none;
  font-weight:      bold;
  } 

.clear { clear: both; height: 0; line-height: 0; }
.floatright { float: right; }

";

my $sumout = "$rdir/$gname.VODKA_report.html";
&writeHtml($gname, $summary, $version, $sumout, $style);

open(SUM, $summary) or die "cannot open $summary\n";
my $h = <SUM>;
while(my $line = <SUM>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $ac = $a[0];
    $ac =~ /(.*)\(.*\)/;
    my $name = $1;
    my $tcnt = $a[1];
    my $mfa = "$loc/results/logo/$name.mapped.fasta";
    my $mfastafile = "fasta/$name.mapped.fasta";
    if (-e $mfa){
	my $x = `mv $mfa $rdir/dvg/fasta/`;
    }
    else{
	unless (-e "$rdir/dvg/fasta/$name.mapped.fasta"){
	    die "ERROR: fasta file $name.mapped.fasta is missing\n";
	}
    }
    my $afa = "$loc/results/logo/$name.all.fasta";
    my $afastafile = "fasta/$name.all.fasta";
    if (-e $afa){
        my $x = `mv $afa $rdir/dvg/fasta/`;
    }
    else{
        unless (-e "$rdir/dvg/fasta/$name.all.fasta"){
            die "ERROR: fasta file $name.all.fasta is missing\n";
        }
    }
    my $logofile;
    if ($tcnt >= 10){
	$logofile = "logo/$name.png";
	my $png = "$loc/results/logo/$name.png";
	if (-e $png){
	    my $x = `mv $png $rdir/dvg/logo/`;
	}
	else{
	    unless (-e "$rdir/dvg/logo/$name.png"){
		die "ERROR: png file $name.png is missing\n";
	    }
	}
    }
    my $output = "$rdir/dvg/report.$name.html";
    my $id = $name;
    &writeHtml_dvg($id,$mfastafile,$afastafile,$tcnt,$logofile, $version, $output,$style);
}
close(SUM);

sub writeHtml{
    my ($genomeName, $summary, $version, $outputfile,$style) =@_;
    open(OUT, ">$outputfile");
    print OUT "<html>\n<head>\n<title>$genomeName VODKA Report</title>\n";
    print OUT "<style type=\"text/css\">\n";
    print OUT "$style\n</style>\n</head>\n";
    print OUT "<body>\n<div class=\"header\">\n<div id=\"header_title\">VODKA Report</div></div>\n";
    print OUT "<div class=\"main\">\n";
    print OUT "<h3>VODKA report for :</h3>\n";
    open(SUM, $summary) or die "cannot open $summary\n";
    my $h = <SUM>;
    chomp($h);
    my @hs = split(/\t/,$h);
    my $slist = "<span id=\"tab\">$hs[2]</span>";
    my $tstring = "<th>A_C</th>\n";
    for(my $i= 1;$i<@hs;$i++){
	$tstring .= "<th>$hs[$i]</th>\n";
	if ($i > 2){
	    $slist .= "<br><span id=\"tab\">$hs[$i]</span>";
	}
    }
    print OUT "<p><font color=#56573C><b>genomeFA:</b></font> $genomeName</p><p><font color=#56573C><b>queryInput:</b></font><br><br>$slist</p><p><font color=#56573C><b>bp_from_right:</b></font> $str_size</p>";
    my $date = `date`;
    print OUT "<font size=-1><font color=#56573C>(report generated on $date)</font></font>";
    print OUT "<h3>Results :</h3>";
    print OUT "<a href=\"$r_name\">$r_name</a>\n";
    print OUT "<h3>Summary Table :</h3>";
    print OUT "<font color=#56573C><font size=-1>click on a A_C value to get FASTA files (and sequence logo for A_C with total count >= 10)<br>";
    print OUT "summary table is also available as <a href=\"$sum_name\">a tab delimited text file</a><br><br></font></font>";
    print OUT "<table>\n<tr>\n";
    print OUT "$tstring\n</tr>\n";
    while(my $line = <SUM>){
	chomp($line);
	my @a = split(/\t/,$line);
	print OUT "<tr>\n";
	for (my $i=0;$i<@a;$i++){
	    if ($i eq 0){
		my $ac = $a[0];
		$ac =~ /(.*)\(.*\)/;
		my $name = $1;
		print OUT "<td><a href=\"dvg/report.$name.html\" >$name</a></td>\n";
	    }
	    else{
		print OUT "<td>$a[$i]</td>\n";
	    }
	}
	print OUT "</tr>\n";
    }
    close(SUM);
    print OUT "</table>\n</div>\n";
    print OUT "<div class = \"footer\">$version</div>\n";
}
sub writeHtml_dvg{
    my ($dvgid, $mfa, $afa,$tcnt, $png, $version, $output, $style) =@_;
    open(OUT, ">$output");
    print OUT "<html>\n<head>\n<title>$dvgid VODKA Report</title>\n";
    print OUT "<style type=\"text/css\">\n";
    print OUT "$style\n</style>\n</head>\n";
    print OUT "<body>\n<div class=\"header\">\n<div id=\"header_title\">$dvgid</div></div>\n";
    print OUT "<div class=\"main\">\n";
    print OUT "<font color=#3F7FBF>\n";
    print OUT "<h3>FASTA</h3></font>\n";
    print OUT "<span id=\"tab\">1. <a href=\"$afa\" >Reads mapping to $dvgid</a> <font color=#56573C>(aligned part marked with >>> and <<< ; breakpoint marked with :::)</font></span><br>\n";
    print OUT "<span id=\"tab\">2. <a href=\"$mfa\" >Mapped only</a></span>\n";
    if ($tcnt >= 10){
	print OUT "<font color=#3F7FBF>\n";
	print OUT "<h3>Sequence Logo</h3></font>\n";
	print OUT "<a href=\"$png\" ><center><img style='height: 90%; width: 90%; object-fit: contain' src=\"$png\"></center></a>\n";
    }
    print OUT "</div>\n";
    print OUT "<div class = \"footer\">$version</div>\n";

}
print "got here\n";
