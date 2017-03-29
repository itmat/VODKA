use warnings;
use strict;

my $usage = "perl cleanup.pl <outloc>


";

if (@ARGV <1){
    die $usage;
}

my $loc = $ARGV[0];
my $bt2_loc = "$loc/bt2_index/";
#gzip fasta and delete fasta.temp
my @g = glob("$bt2_loc/*fasta");
foreach my $fasta (@g){
    if (-e "$fasta.gz"){
	`rm $fasta.gz`;
    }
    `gzip $fasta`;
}
my @t = glob("$bt2_loc/*fasta.temp");
foreach my $tfa (@t){
    `rm $tfa`;
}

=comment
#delete alignment directory
my $aln_dir = "$loc/alignment";
if (-d $aln_dir){
    `rm -r $aln_dir`;
}

#delete results directory
my $res_dir = "$loc/results";
if (-d $res_dir){
    `rm -r $res_dir`;
}
=cut
print "got here\n";







