open In,"test.txt";
open Out,">inverts.txt";

while(<In>){
	chomp;
	@arr =split(" ",$_);
	$HZ =shift(@arr);
	if(@arr == 1){
		$py =$arr[0];
	}else{
		$py =join(" ",@arr);
	}
	$py =~s/\d//g;
	#print $py." ".$HZ."\n";
	push(@{$hash{$py}},$HZ);

}

foreach $py(sort keys %hash){
	print Out $py."#";
	foreach (@{$hash{$py}}){
		print Out $_." ";
	}
	print Out "\n";
}

close();