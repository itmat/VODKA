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
    my $seq = $a[7];
    push(@{$TCNT{$nm}}, $seq);
    $SEQRUN{$seq} = 1;
}
close(IN);
open(OUT, ">$breakdown");
print OUT "N_M\ttotal_count";
foreach my $seq (sort keys %SEQRUN){
    print OUT "\t$seq";
}
print OUT "\n";
foreach my $nm (keys %TCNT){
    my $cnt = @{$TCNT{$nm}};
    print OUT "$nm\t$cnt";
    foreach my $seq (sort keys %SEQRUN){
	my $count_seq = grep { $_ eq $seq } @{$TCNT{$nm}};
	print OUT "\t$count_seq";
    }
    print OUT "\n";
}
close(OUT);
print "got here\n";

