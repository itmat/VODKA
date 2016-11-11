use warnings;
use strict;
no warnings ('uninitialized', 'substr');
$|=1;

my $USAGE = "perl search1.pl <samfile> <search1 output>

";

if (@ARGV<2){
    die $USAGE;
}

open(INFILE, $ARGV[0]);
open(OUTFILE, ">$ARGV[1]");

my $cutoff = 15;
my (@a, $seq, $A, $B, $cig, $d1, $d2, $t1, $t2, $x, $y, $str);
while(my $line = <INFILE>) {
    undef @a;
    undef $seq;
    undef $A;
    undef $B;
    undef $cig;
    undef $d1;
    undef $d2;
    undef $t1;
    undef $t2;
    undef $x;
    undef $y;
    undef $str;
    if($line =~ /^@/) {
	next;
    }
    chomp($line);
    @a = split(/\t/,$line);
    if($a[5] =~ /\*/) {
	next;
    }
    $line =~ /NM:i:(\d+)/;
    my $NM = $1;
    my $N = $a[3];
    $a[5] =~ /[^M\d]*(\d+)M/;
    my $M = $1;
    my $A = 100 - $N;
    my $B = $N + $M - 100;
    $seq = $a[9];
    $cig = $a[5];
    $cig =~ /^(\d+)(.)(\d+)(.)/;
    $d1 = $1;
    $t1 = $2;
    $d2 = $3;
    $t2 = $4;
    $str = "";
    if($t1 eq "S" && $t2 eq "M") {
	$y = $d1+1;
	$str = $str . substr($seq,0,$y);
	$str = $str . ">>>";
	$str = $str . substr($seq,$y,$A);
	$str = $str . ":::";
	$x = $y + $A;
	$str = $str . substr($seq,$x,$B);
	$str = $str . "<<<";
	$x = $x + $B;
	$y = length($seq) - $x;
	$str = $str . substr($seq,$x,$y);
    } else {
	$cig =~ /^(\d+)(.)/;
	$d1 = $1;
	$t1 = $2;
	$str = "";
	if($t1 eq "M") {
	    $str = ">>>";
	    $str = $str . substr($seq,0,$A);
	    $str = $str . ":::";
	    $x = $A;
	    $str = $str . substr($seq,$x,$B);
	    $str = $str . "<<<";
	    $x = $x + $B;
	    $y = length($seq) - $x;
	    $str = $str . substr($seq,$x,$y);
	}
    }
    if($A >= $cutoff && $B >= $cutoff) {
	print OUTFILE "$a[0]\t$a[2]\t$a[3]\t$a[5]\t$A\t$B\t$NM\t$str\n";
    }
}
close(INFILE);
close(OUTFILE);


print "got here\n";
