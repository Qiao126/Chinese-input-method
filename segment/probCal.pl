open In,"bicount.txt";

open a1,">arg1.txt";

open a2,">arg2.txt";


while(<In>){

	#print $_."\n";

	@arr =split(" ",$_);

	$u_hash{$arr[0]}+=$arr[2];

	$b_hash{$arr[0]." ".$arr[1]}+=$arr[2];

	$u_total+=$arr[2];


}


foreach (sort keys %u_hash){
	#print $_." ".$u_hash{$_}."\n";
	if($u_hash{$_}>0){
		print a1 $_."\t".log($u_hash{$_}/$u_total)."\n";
	}
	
}

foreach (sort keys %b_hash){

	($w1,$w2) =split(" ",$_);

	if($b_hash{$_}>0){
		$prob =log($b_hash{$_}/$u_hash{$w1});	
	}

	print a2 $_."\t".$prob."\n";
}

