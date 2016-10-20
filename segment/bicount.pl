use Encode;

system("time /t");

$g_MaxBiNum=10000000;

%dict_hash ={};

$total_word =0;

initDict("b_dict.txt");

#利用词表分词

BiCount("train.001");

writeOut("bicount.txt");


system("time /t");

sub initDict{

	my($File) =@_;
	
	open(In,"$File");
	
	while(<In>){
		chomp;
		$dict_hash{$_}++;
	}
	
	close(In);
			
}

sub writeOut{
	
	my($File) =@_;

	open(Out,">".$File);
	
	foreach(sort keys %bi_hash){
			$p =$bi_hash{$_};
			print Out $_." ".$p."\n";
		}
		
	close(Out);
}

sub BiCount
{
	my($File)=@_;
	$BiFile="tmp";
	open(In,"$File");
	$ZiNum=0;
	$ID=0;
	@BiTmp=();

	$index =0;

	while(<In>){

		chomp;

		$line=$_;
		
		$line =~s/\s+//;
		
		$n_index=0;
		
		$Len =1;

		$len=length($line);

		while($len > 0 ){

			$len=length($line);

			$isDict =0;

			$cLen =0;

			$index =0;

			if ( ord($line) & 0x80){
					$Len=2;
			}

			for($i =$len;$i>0;$i-=$Len){

				$Len =1;
			
				$H2 =substr($line,0,$i);

				if ( ord($H2) & 0x80){
					$Len=2;
				}

				if(defined $dict_hash{$H2}){
					push(@words,$H2);
					if(@words > 1){
						$bi_words =$H2." ".shift(@words);
						$bi_hash{$bi_words}++;
						$total_word++;
					}
					$cLen =$i;
					$isDict =1;
					last;
				}

			}

			if($isDict == 0){
				push(@words,$H2);
				if(@words > 1){
					$bi_words =$H2." ".shift(@words);
					$bi_hash{$bi_words}++;
					$total_word++;
				}
				$cLen=$Len;
			}

			$line =substr($line,$cLen,$len-$cLen);
		
		}	
	}

		
	close(In);
}



