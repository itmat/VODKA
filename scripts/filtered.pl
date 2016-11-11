open(INFILE, $ARGV[0]);
while($line = <INFILE>) {
    chomp($line);
    @a = split(/\t/,$line);
    $hash{$a[1]} = 1;
}
close(INFILE);

open(INFILE, "KJ672445_RESULTS.txt");
while($line = <INFILE>) {
    chomp($line);
    @a = split(/\t/,$line);
    $id = $a[1];
    if($hash{$id} =~ /\S/) {
	print "$line\n";
    }
}
close(INFILE);
