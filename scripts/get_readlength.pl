#!/usr/bin/env perl
use warnings;
use strict;

my $usage = "perl get_readlength.pl <unaligned> [option]

 -h : print usage


";

if (@ARGV<1){
    die $usage;
}

my $files = $ARGV[0];
for (my $i=0;$i<@ARGV;$i++){
    if ($ARGV[$i] eq '-h'){
        die $usage;
    }
}

my $max_length = 0;
open(IN, $files);
while(my $line = <IN>){
    chomp($line);
    my $cnt = 0;
    my $x;
    my $rownum = 2;
    my ($gz, $fafq) = &get_filetype($line);
    while ($cnt < 200){
        if ($gz eq "true"){
	    $x = "zcat $line | sed -n '$rownum" . "{p;q;}'";
	}
	else{
            $x = "sed -n '$rownum"."{p;q;}' $line";
	}
        my $y = `$x`;
        chomp($y);
        my $y_len = length($y);
        if ($y_len eq 0){
            last;
        }
	if ($y_len > $max_length){
	    $max_length = $y_len;
	}
        unless ($max_length == 0){
            $cnt++;
            $rownum += 4;
        }
    }
}
print "$max_length\n";


sub get_filetype{
    my ($file) = @_;
    my $ft = `file $file`;
    chomp($ft);
    my $gz = "";
    if ($ft =~ /compressed/){
	$gz = "true";
    }
    else{
	$gz = "false";
    }
    my $firstline;
    if ($gz eq "true"){
        $firstline = `gunzip -c $file | head -1`;
    }
    else{
        $firstline = `head -1 $file`;
    }
    my $fqfa = "";
    if ($firstline =~ /^@/){
	$fqfa = "fq";
    }
    else{
        if ($firstline =~ /^>/){
	    $fqfa = "fa";
        }
        else{
            die "\nERROR: Unaligned files need to be in fastq or fasta format.\n\n";
        }
    }
    return ($gz, $fqfa);
}
