open(In,"test.txt");
open(Out,">b_dict.txt");

while(<In>){
		chomp;
		($word,$py) =split(" ",$_); 
		print Out $word."\n"; 
	}
	
close();
