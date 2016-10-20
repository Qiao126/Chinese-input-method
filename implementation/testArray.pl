for($i =0;$i<2;$i++){
	my @array =($i,$i,$i);
	if($i==0)
	{
		$ref01 =\@array;
	}
	if($i==1)
	{
		$ref02 =\@array;
	}
}

	print $ref01->[1]."\t";	
	print $ref02->[1];