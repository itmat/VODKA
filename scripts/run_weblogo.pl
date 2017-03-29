use warnings;
use strict;

my $usage= "perl run_weblogo.pl <logodir> <weblogoloc>

";

if (@ARGV<2){
    die $usage;
}

my $loc = $ARGV[0];
my $weblogo = $ARGV[1];
my $wldir = $weblogo;
$wldir =~ s/weblogo$//;
my $aclist = "$loc/list.txt";
open(IN, $aclist) or die "cannot open $aclist\n";
while(my $line = <IN>){
    chomp($line);
    my $forlogo = "$loc/for_logo.$line.fasta";
    my $tref = "$loc/TempREF.$line.fasta";
    my $t = `tail -1 $tref`;
    chomp($t);
    $t =~ /(.*)\|\|\|(.*)/;
    my $str1 = $1;
    my $str2 = $2;
    my $cnt1 = length($str1);
    my $cnt2 = length($str2);
    my ($A, $C) = split("_",$line);
    my $cntC = $C+$cnt1-1;
    my $annot1= $cntC;
    my $midC = int(($cntC+$C)/2);
    for(my $i=$cntC-1;$i>=$C;$i--){
	if ($i == $C){# || ($i == $midC)){
	    $annot1 .= ",$i";
	}
	else{
	    $annot1 .= ",";
	}
    }
    my $annot2="$A";
    my $midA = int(($A+$A+$cnt2-1)/2);
    for(my$i=$A+1;$i<$A+$cnt2;$i++){
	if ($i == $A+$cnt2-1){ #(($i == $midA) || 
	    $annot2 .= ",$i";
	}
	else{
	    $annot2 .= ",";
	}
    }
    my $annot = "$annot1,$annot2";
    my $command = `$weblogo -F png -f $forlogo --annotate $annot -n $cnt1 -t '$line' --title-fontsize 18 --number-fontsize 10 -c classic -s large -o $loc/$line.png`;
}
close(IN);

print "got here\n";


