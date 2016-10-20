use Encode;
system("time /t");
$g_MaxBiNum=10000000;
BiCount("train");
MergeBi(\@BiTmp,"bi.txt");
foreach (@BiTmp){
		unlink($_);
}
system("time /t");

sub BiCount
{
	my($File)=@_;
	$BiFile="tmp";
	open(In,"$File");
	$ZiNum=0;
	$ID=0;
	@BiTmp=();
	while(<In>){
		chomp;	
		s/\s+//g;
		#$Str=decode("gb2312",$_);
		#@HZs=$Str=~/./g;
		#@HZs=();
		#SplitHZ($_,\@HZs);
		$Line=$_;
		while( $Line ne "" ){
			$Len=1;
			if ( ord($Line) & 0x80 ){
				$Len=2;
			}
			$H2=substr($Line,0,$Len);
			if ( $H1 ne  "" ){
				$Bi=$H1."_".$H2;
				$hashBi{$Bi}++;
			}
			$H1=$H2;
			$ZiNum++;
		
			if ( $ZiNum > $g_MaxBiNum ){
				$BiFileTmp=$BiFile."_".$ID;
				push(@BiTmp,$BiFileTmp);
				open(Out,">$BiFileTmp");
				print "$BiFileTmp done!\n";
				foreach (sort keys %hashBi ){
					print Out "$_\t$hashBi{$_}\n";
				}
				%hashBi=();
				$ZiNum=0;
				close(Out);
				$ID++;
			}
			
			$Line=substr($Line,$Len,length($Line)-$Len);
		}
	}
		
	close(In);
	
}

sub MergeBi
{
	my($RefBiFileList,$Merged)=@_;
	
	open(Out,">$Merged");

	foreach (@{$RefBiFileList}){
		my $H="F".$_;
		open($H,"$_");
		if ( <$H>=~/(\S+)\t(\d+)/ ){
			${$hash{$1}}{$H}=$2;		
		}
	}
	@BiStr=sort keys %hash;
	while( @BiStr > 0 ){
		$Num=0;
		@Fhandle=();
		foreach $Handle(keys %{$hash{$BiStr[0]}} ){
			$Num+=${$hash{$BiStr[0]}}{$Handle};
			push(@Fhandle,$Handle);
		}
		print Out "$BiStr[0]\t$Num\n";
		
		delete $hash{$BiStr[0]};
		foreach $Handle(@Fhandle){
			
			if ( <$Handle>=~/(\S+)\t(\d+)/ ){
				${$hash{$1}}{$Handle}=$2;		
			}
		}
		@BiStr=sort keys %hash;
	}
	
	
	foreach (@{$RefBiFileList}){
		my $H="F".$_;
		close($H);
	}
	
}


sub SplitHZ
{
		my($Line,$Ref)=@_;
		while( $Line ne "" ){
			$Len=1;
			if ( ord($Line) & 0x80 ){
				$Len=2;
			}
			push(@{$Ref},substr($Line,0,$Len));
			$Line=substr($Line,$Len,length($Line)-$Len);
		}
}
