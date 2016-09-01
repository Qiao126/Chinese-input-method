#!/bin/bash
while true
do
	clear;
	if [ "$1" == "--AMPM" ]; then
		hourt=$(date +%H);
		if [ $hourt -gt 12 ]; then
			((hourt -= 12))
			minsec=$(date +%M:%S);
			nowtime="$hourt:$minsec PM"
			echo $nowtime;
		else	
			nowtime="$(date +%T) AM"
			echo $nowtime;  
		fi
	else
		nowtime=$(date +%T);
		echo $nowtime;
	fi
	sleep 1;	
done

