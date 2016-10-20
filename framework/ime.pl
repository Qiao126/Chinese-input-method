
sub IME
{
	my($Inp)=@_;
	my @Lattice=();
	my $Result;
	Buildlattice($Inp,\@Lattice);
	Search(\@Lattice);
	$Result=Backward(\@Lattice);
	return $Result;
}


sub InitNGram
{
	my($Unigram,$Bigram)=@_;
}



sub InitPY2HZ
{
	my($File)=@_;
}


sub GetUni
{
	my($HZ)=@_;
}


sub GetBi
{
	my($HZ1,$HZ2)=@_;
}


sub Buildlattice
{
	my($Inp,$RefLattice)=@_;
	@Pys=split(" ",$Inp);
	unshift(@Pys,"BEG");
	push(@Pys,"END");

	for($i=0;$i<@Pys;$i++){
		my @OneColumn=();
		@Candidate=();
		GetAllCandidate($Pys[$i],\@Candidate);
		foreach (@Candidate){
			my @OneUnit=();
			$OneUnit[0]=$Pys[$i];	
			$OneUnit[1]=$_;	
			$OneUnit[2]=0;	
			$OneUnit[3]=0;
			push(@OneColumn,\@OneUnit);
		}
		push(@{$RefLattice},\@OneColumn);
	}
}


sub		GetAllCandidate
{
	my($PY,$refcandidate)=@_;
}


sub Search
{
	my($RefLattich)=@_;
	
	for($i=1;$i<@{$RefLattich};$i++){
		$RefCurrent=${$RefLattich}[$i];
		foreach $RefCurHZ(@{$RefCurrent}){
			$Max=-1e1000;
			$Num=0;
		$RefPrevious=${$RefLattich}[$i-1];
			foreach $RefPrevHZ(@$RefPrevious){
			$Val=GetProb(${$RefPrevHZ}[1],${$RefCurHZ}[1])+${$RefPrevHZ}[2];
				if ( $Val > $Max){
					$Max=$Val;
					$MaxProb=$Num;
				}
				$Num++;
			}
			${$RefCurHZ}[2]=$Max;
		  ${$RefCurHZ}[3]=${$RefPrevious}[$MaxProb];
		}
	}	
}


sub Backward
{
	my ($RefLattich)=@_;
  my $RefEnd=${$RefLattich}[@$RefLattich-1];
  $BackPointer=${${$RefEnd}[0]}[3];
	my @ResultArray;
	while( ${$BackPointer}[3] != 0 ){
	$Pair=${$BackPointer}[1];
		unshift(@ResultArray,$Pair);
		$BackPointer=${$BackPointer}[3];
	}
	my $Result=join(" ",@ResultArray);
	return $Result;
}


sub GetProb
{
	my($HZ1,$HZ2)=@_;
	if ($HZ1 eq "BEG" ){
		$Val=GetUni($HZ2);
	}elsif ($HZ2 eq "END" ){
		$Val=0.0;
	}else{
		$Val=GetBi($HZ1,$HZ2);
	}
	return $Val;
	
}
	
