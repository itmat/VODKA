use warnings;
use strict;

my $usage= "perl make_fa_for_each_ac.pl <filtered.txt> <3000 ref fasta> <outdir>

";

if (@ARGV<3){
    die $usage;
}

my $filtered = $ARGV[0];
my $ref = $ARGV[1];
my $loc = $ARGV[2];
unless(-d $loc){
    `mkdir $loc`;
}
my $tref = "$ref.temp";
my $aclist = "$loc/list.txt";
open(IN,$filtered) or die "cannot open $filtered\n";
my $h = <IN>;
my %SEEN;
my %OUTFILES;
my %OUTFILES_ALL;
while(my $line = <IN>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $ac = $a[0];
    $ac =~ /(.*)\(.*\)/;
    my $name = $1;
    if (exists $SEEN{$name}){
	$SEEN{$name}++;
    }
    else{
	$SEEN{$name} = 1;
    }
}
close(IN);

foreach my $name (keys %SEEN){
    my $out = "$loc/$name.mapped.fasta";
    open($OUTFILES{$name}, ">$out");
}

open(IN,$filtered) or die "cannot open $filtered\n";
$h = <IN>;
while(my $line = <IN>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $ac = $a[0];
    $ac =~ /(.*)\(.*\)/;
    my $name = $1;
    my $seqid = $a[1] . ":::::" . $a[8];
    my $seqm = $a[10];
    my $seqa = $a[9];
    print {$OUTFILES{$name}} ">$seqid\n$seqm\n";
}
close(IN);
foreach my $file (keys %OUTFILES){
    close($OUTFILES{$file});
}

foreach my $name (keys %SEEN){
    my $outall = "$loc/$name.all.fasta";
    open($OUTFILES_ALL{$name}, ">$outall");
}
open(IN,$filtered) or die "cannot open $filtered\n";
$h = <IN>;
while(my $line = <IN>){
    chomp($line);
    my @a = split(/\t/,$line);
    my $ac = $a[0];
    $ac =~ /(.*)\(.*\)/;
    my $name = $1;
    my $seqid = $a[1] . ":::::" . $a[8];
    my $seqm = $a[10];
    my $seqa = $a[9];
    print {$OUTFILES_ALL{$name}} ">$seqid\n$seqa\n";
}
close(IN);
foreach my $file (keys %OUTFILES_ALL){
    close($OUTFILES_ALL{$file});
}

open(LT, ">$aclist") or die "cannot open $aclist\n";
foreach my $ac (keys %SEEN){
    if ($SEEN{$ac} > 0){
	print LT "$ac\n";
    }
}
close(LT);

open(RF, $ref) or die "cannot open $ref\n";
while(my $id = <RF>){
    my $seq = <RF>;
    chomp($id, $seq);
    $id =~ s/^>//;
    $id =~ /(.*)\(.*\)/;
    my $name = $1;
    if (exists $SEEN{$name}){
	if ($SEEN{$name} > 0){
	    my $outref = "$loc/REF.$name.fasta";
	    open(OUT ,">$outref");
	    print OUT ">$name\n$seq\n";
	    close(OUT);
	}
    }
}
close(RF);

open(TRF, $tref) or die "cannot open $tref\n";
while(my $id = <TRF>){
    my $seq = <TRF>;
    chomp($id, $seq);
    $id =~ s/^>//;
    $id =~ /(.*)\(.*\)/;
    my $name = $1;
    if (exists $SEEN{$name}){
        if ($SEEN{$name} > 0){
            my $outref = "$loc/TempREF.$name.fasta";
            open(OUT ,">$outref");
            print OUT ">$name\n$seq\n";
            close(OUT);
        }
    }
}
close(TRF);

print "got here\n";

