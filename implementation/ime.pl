$g_MinProb=-10e10;
$MinHZ=RetHZIdx("啊");
$MaxHZ=RetHZIdx("座");


print "Init PY2HZ Invert table...\n";
#InitPY2HZ("invert.txt");
InitPY2HZ("inverts.txt");

print "done!\n";
print "Init ngram...\n";
InitNGram("a1.txt","a2.txt");
print "done!\n";

while (1){
	print "输入拼音(q 退出)\n>";
	$Inp=<stdin>;
	chomp($Inp);
	if ( $Inp eq "q" ){
		last;
	}
	$IMEResult=IME($Inp);
	print "$IMEResult\n";
}

sub IME
{
	#输入的pinyin
	
	my($Inp)=@_;
	my @Lattice=();
	my $Result;
	
	Buildlattice($Inp,\@Lattice);
	
	Search(\@Lattice);
	
	$Result=Backward(\@Lattice);
	
	return $Result;
}

sub Buildlattice
{
	my($Inp,$RefLattice)=@_;

	@Pys=split(" ",$Inp);

	unshift(@Pys,"BEG"); #放在数组开头

	push(@Pys,"END");
	
	for($i=0;$i<@Pys;$i++){
				
		my @OneColumn=();
			
		my @word =();
				
		if($i == 0 || $i == @Pys-1){
			$canWord =$Pys[$i];	
			my @wordCandidate =();
			GetAllCandidate($canWord,\@wordCandidate);
			foreach (@wordCandidate){
				my @OneUnit =();
				$OneUnit[0]=$Pys[$i];  
				$OneUnit[1]=$_;				
				$OneUnit[2]=0;	
				$OneUnit[3]=0;
				my $ref =\@OneUnit;
				push(@OneColumn,$ref);			#每个拼音的候选词集合	
			}	
		}
		else{
			
			for($j =$i;$j>0;$j--){
				
				unshift(@word,$Pys[$j]);
	
				$canWord =join(" ",@word);
	
				#print "Now i is ".$i."candicate word is :".$canWord."\n";
				
				my @wordCandidate =();
			
				GetAllCandidate($canWord,\@wordCandidate);
			
				#print "Get all wordCandidate:";
			
				#print @wordCandidate;
			
				#print "\n";
			
				foreach (@wordCandidate){
					my @OneUnit =();
					$OneUnit[0]=$Pys[$i];  
					$OneUnit[1]=$_;				
					$OneUnit[2]=0;	
					$OneUnit[3]=0;
					my $ref =\@OneUnit;
					push(@OneColumn,$ref);			#每个拼音的候选词集合	
				}	
			}
		}	
		push(@{$RefLattice},\@OneColumn);
	}
	
	foreach $k(@{$RefLattice}){
		foreach $n(@{$k}){
			foreach (@{$n}){
		#		print $_."\t";	
			}
		#	print "\n";
		}
		#print "\n";
	}
}

sub	GetAllCandidate
{
	my($PY,$refcandidate)=@_;
	if ( defined $hashPy2HZ{$PY} ){
			$RefHZ=$hashPy2HZ{$PY};
			push(@{$refcandidate},@{$RefHZ});
  }
}

sub Search
{
	my($RefLattich)=@_;   #拼音#字词数组（拼音，字词，2,3）
	
	for($i=1;$i<@{$RefLattich};$i++){				
		
		$RefCurrent=${$RefLattich}[$i];
		
		foreach $RefCurHZ(@{$RefCurrent}){		#OneColumn
		
			$Max=-1e1000;												#OneUnit
		
			$Num=0;
			
			print "Current Word is :".${$RefCurHZ}[1]."\n";
			
			if(${$RefCurHZ}[1] eq "BEG" || ${$RefCurHZ}[1] eq "END" ){
				$prvCount =1;	
			}
			else{
				$prvCount =length(${$RefCurHZ}[1])/2;		
			}
			
			$prev =$i-$prvCount;
			
			$RefPrevious=${$RefLattich}[$i-$prvCount];  #prev prob
			
			print "Current is :".$i."Prev is ".$prev."PrevCount is :".$prvCount."\n";
			
			print "Caculate prob: \n";
			
			foreach $RefPrevHZ(@{$RefPrevious}){			#每个拼音对应前面的汉字
				
			
				$Val=GetProb(${$RefPrevHZ}[1],${$RefCurHZ}[1]) + ${$RefPrevHZ}[2];
			
				print ${$RefPrevHZ}[1]."\t".${$RefCurHZ}[1]."\t".$Val."\n";
				
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
			#print $HZ1." ".$Val."\n";
	}elsif ($HZ2 eq "END" ){
		$Val=0.0;
	}else{
			$Val=GetBi($HZ1,$HZ2);
	}
	return $Val;
	
}

sub InitNGram
{
	
	my($Ugram,$Bgram)=@_;
	
	open(In1,"$Ugram");
	open(In2,"$Bgram");
	
	@Un =<In1>;
	@Bi =<In2>;
	
	foreach (@Un){
		#print $w." ".$p."\n";
		($w , $p ) =split("\t",$_);
		$HashUni{$w} =$p;		
		#print $HashUni{"我"};
	}
	
	foreach (@Bi){
		#print $w." ".$p."\n";
		($w , $p ) =split("\t",$_);
		($hz,$t)= split(" ",$w);
		${$hashBi{$hz}}{$t} =$p;		
	}
	
	close(In);
}



sub InitPY2HZ
{
	my($File)=@_;
	open(In,"$File");
	while(<In>){
		chomp;
		if($_=~/#/){
			($PY,$HZ) =split("#",$_);
			my @HZs=split(" ",$HZ);
			$hashPy2HZ{$PY}=\@HZs;
		}
	}
	close(In);
}


sub RetHZIdx
{
	my($HZ)=@_;
	my @HZs=unpack("C*",$HZ);
	$HZIdx=($HZs[0]-0xb0)*94+($HZs[1]-0xa1);
	return $HZIdx;
}


sub GetUni
{
	my($HZ)=@_;
	if(defined $HashUni{$HZ}){
		return $HashUni{$HZ};
	}else{
		return $g_MinProb;
	}
	
}


sub GetBi
{
	my($HZ1,$HZ2)=@_;
	if(defined ${$hashBi{$HZ1}}{$HZ2}){
		return ${$hashBi{$HZ1}}{$HZ2};
	}else{
		return $g_MinProb;
	}
}


	
