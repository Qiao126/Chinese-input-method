#!/bin/bash

if [ $# -lt 2 ]; then
	echo invalid input;exit;
fi

op=$1; 
if [ "$op" == "S" ]; then
	ans=0
elif [ "$op" == "P" ]; then
	ans=1
else
	ans=$2
fi
shift;  

while [ $# -gt 0 ]  
do    
	if [ "$op" == "S" ]; then
		((ans += $1))
		shift;
	elif [ "$op" == "P" ]; then
		((ans *= $1))
		shift;
	elif [ "$op" == "M" ]; then
		if [ $1 -gt $ans ]; then
			((ans = $1))
		fi
		shift;
	elif [ "$op" == "m" ]; then
		if [ $1 -lt $ans ]; then
			((ans = $1))
		fi
		shift;
	else
		echo invalid input;exit;
	fi
done

echo $ans

