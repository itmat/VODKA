use warnings;
use strict;

my $USAGE = "perl get_breakdown.pl <filtered results>


";


if (@ARGV<1){
    die $USAGE;
}


my $filtered = $ARGV[0];
my $breakdown = $filtered;
$breakdown =~ s/.txt$/.SUMMARY.txt/;
my %TCNT;
my %SEQRUN;
open(IN, $filtered) or die "cannot open '$filtered;\n";
my $h = <IN>;
while(my $line = <IN>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $nm= $a[0];
    my $seq = $a[8];
    push(@{$TCNT{$nm}}, $seq);
    $SEQRUN{$seq} = 1;
}
close(IN);
open(OUT, ">$breakdown");
print OUT "A_C(A_C)\ttotal_count";
foreach my $seq (sort keys %SEQRUN){
    print OUT "\t$seq";
}
print OUT "\n";
close(OUT);
my $temp = "$breakdown.tmp";
open(TMP, ">$temp");
foreach my $nm (sort keys %TCNT){
    my $cnt = @{$TCNT{$nm}};
    print TMP "$nm\t$cnt";
    foreach my $seq (sort keys %SEQRUN){
	my $count_seq = grep { $_ eq $seq } @{$TCNT{$nm}};
	print TMP "\t$count_seq";
    }
    print TMP "\n";
}
close(TMP);
my $s = `sort -nrk 2 $temp >> $breakdown`;
if (-e $temp){
    `rm $temp`;
}
print "got here\n";

