$genome[0] = "KJ672445_3kb_100bp";
$genome[1] = "KJ672447_3kb_100bp";
$genome[2] = "KJ672475_3kb_100bp";
$genome[3] = "KJ672483_3kb_100bp";
$genome[4] = "KJ672484_3kb_100bp";

for($G=0; $G<=4; $G++) {
    undef %DATA;
    $str = "";
    for($R=1; $R<=4; $R++) {
	$dir = "Yan$R" . "_S$R";
	$x = `cat $dir/$genome[$G]/search1_out.R1.new.txt`;
	$x =~ s/\n/\tYan$R.fwd\n/gs;
	$str = $str . $x;
	$x = `cat $dir/$genome[$G]/search1_out.R2.new.txt`;
	$x =~ s/\n/\tYan$R.rev\n/gs;
	$str = $str . $x;
    }
    chomp($str);
    @a = split(/\n/,$str);
    for($i=0; $i<@a; $i++) {
	@b = split(/\t/,$a[$i]);
	if($b[7] !~ /\S/) {
	    print "$str";
	    exit();
	}
	$DATA{$b[1]} = $DATA{$b[1]} . "$b[1]\t$b[0]\t$b[4]\t$b[5]\t$b[2]\t$b[3]\t$b[6]\t$b[8]\t$b[7]\n";
    }
    $x = $genome[$G];
    $x =~ s/_.*//;
    $filename = $x . "_RESULTS.txt";
    open(OUTFILE, ">$filename");
    foreach $key (keys %DATA) {
	print OUTFILE "$DATA{$key}";
    }
    close(OUTFILE);
}


# NS500568:7:H3FGFAFXX:1:11103:20523:19140        158_1534        17      98M11S  83      15              Yan2.fwd

# NS500568:7:H3FGFAFXX:2:11105:23262:1923 838_868 85      54S31M58S       15      16      CTTTACATATGATATTCCATAGGCTTAAAGTTTATCCTCCATTTCTTATTAATCT>>>ATATCCCACTCCCCA:::TAATTTAATATTGGCT<<<GACATTTTTCTTATATTCAGGATAGAATTCCTCCTCTCTCATCAGCACGCGTCGACC
