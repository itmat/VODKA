use warnings;
use strict;

if (@ARGV<2){
    die "perl get_unmapped_results_only.pl <results sam> <results txt>

";

}
my $samfile= $ARGV[0];
my $results = $ARGV[1];
my $filtered = $results;
$filtered =~ s/.txt$/.filtered.txt/;
my %UNM_IDS;
open(SAM, $samfile) or die "cannot open '$samfile'\n";
while(my $line = <SAM>){
    chomp($line);
    if ($line =~ /^@/){
        next;
    }
    my @a = split(/\t/, $line);
    my $id = $a[0];
    my $flag = $a[1];
    if ($flag == 4){
	my @b = split(":::::", $id);
	my $sample = $b[@b-1];
	$id =~ s/:::::$sample$//;
        $UNM_IDS{$id} = $sample;
    }
}
close(SAM);

open(IN, $results) or die "cannot open $results\n";
open(OUT, ">$filtered") or die "cannot open $filtered\n";
my $header = <IN>;
print OUT "$header";
while(my $line = <IN>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $rid = $a[1];
    my $seqid = $a[7];
    if (exists $UNM_IDS{$rid}){
	if ($seqid eq $UNM_IDS{$rid}){
	    print OUT "$line\n";
	}
    }
}
close(IN);
close(OUT);

print "got here\n";
