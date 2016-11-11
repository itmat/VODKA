#!/usr/bin/env perl

use warnings;
use strict;
my $USAGE = "perl genomefa_to_newfasta.pl <input fasta> <bases_from_the_right> <size> <outputfile>

<input fasta>
<bases_from_the_right>: e.g. 3000
<size>: e.g. 100
<outputfile>

";
if (@ARGV<4){
    die $USAGE;
}
my $fasta = $ARGV[0];
my $bases_to_use = $ARGV[1];
$bases_to_use *= -1;
my $bp = $ARGV[2];
my $out = $ARGV[3];
my $ft = `file $fasta`;
chomp($ft);
my $gz = "";
if ($ft =~ /compressed/){
    $gz = "true";
}
else{
    $gz = "false";
}
if ($gz eq "true"){
    my $pipecmd = "gunzip -c $fasta";
    open(IN, "-|", $pipecmd) or die "Opening pipe [$pipecmd]: $!\n+";
}
else{
    open(IN, $fasta) or die "cannot open file '$fasta'\n";
}
my $flag = 0;
my $onelineseq = "";
while(my $line = <IN>) {
    if($line =~ />/) {
	if($flag == 0) {
	    $onelineseq .= $line;
	    $flag = 1;
	}
	else {
	    $onelineseq .= "\n$line";
	}
    }
    else {
	chomp($line);
	$line = uc $line;
	$onelineseq .= $line;
    }
}
close(IN);
my $threekb = substr($onelineseq, $bases_to_use);

my $s2_cnt = 0;
my $length = length($threekb);
my $s2_start = $length - $bp - $s2_cnt;
open(OUT,">$out");
while ($s2_start > 0){
    my $s2_st = -$bp-$s2_cnt;
    my $s1_cnt = 0;
    my $s2 = substr($threekb, -$bp-$s2_cnt, $bp);
    my $s2_rc = &reversecomplement($s2);
    for (my $i=0;$i<$length;$i++){
	my $s1 = substr($threekb, $s1_cnt, $bp);
	my $s1_end = $s1_cnt+$bp;
	$s1_cnt++;
	if ($s2_start - $s1_end >= 0){ #does not overlap
	    print OUT ">$s1_end"."_"."$s2_start\n";
	    print OUT "$s2_rc$s1\n";
	}
	else{
	    last;
	}
    }
    $s2_cnt++;
    $s2_start = $length - $bp - $s2_cnt;
}
close(OUT);

print "got here\n";

sub reversecomplement () {
    (my $sq) = @_;
    my @A = split(//,$sq);
    my $rev = "";
    for(my $i=@A-1; $i>=0; $i--) {
        my $flag = 0;
        if($A[$i] eq 'A') {
            $rev = $rev . "T";
            $flag = 1;
        }
        if($A[$i] eq 'T') {
            $rev = $rev . "A";
            $flag = 1;
        }
        if($A[$i] eq 'C') {
            $rev = $rev . "G";
            $flag = 1;
        }
        if($A[$i] eq 'G') {
            $rev = $rev . "C";
            $flag = 1;
        }
        if($flag == 0) {
            $rev = $rev . $A[$i];
        }
    }
    return $rev;
}
