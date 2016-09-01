#! /bin/bash

if [ $# -eq 1 ];then
	if [[ $1 =~ -- ]]; then
		flag=$1;
	else
		place=$1;
	fi
elif [ $# -eq 2 ];then
	place=$1;
	flag=$2;
elif [ $# -ne 0 ];then
	echo invalid input; exit;
fi

declare -a arr1
declare -a arr2

unset arr1;
unset arr2;

getTime() {
  while [[ $1 ]]
  do
    if [[ $1 =~ \<DeparturePlatformName\>([0-9]) ]]; then
		
		platform=${BASH_REMATCH[1]};
	fi
	if [[ $1 =~ \<ExpectedDepartureTime\>.*T([0-9]+:[0-9]+:[0-9]+)\+02:00 ]]; then
		dtime=${BASH_REMATCH[1]};
		
		if [ "$platform" == "1" ]; then
			arr1=("${arr1[@]}" "${BASH_REMATCH[1]}")  #append to array
		elif [ "$platform" == "2" ]; then
			arr2=("${arr2[@]}" "${BASH_REMATCH[1]}")  
		fi
	fi
	   
	shift
  done
}

if [ "$place" == "Blindern" ]; then
	stopid=3010360;
elif [ "$place" == "Majorstuen" ]; then
	stopid=3010200;
else
	stopid=3010370;
	place="Forskningsparken";
fi

url="http://reisapi.ruter.no/StopVisit/GetDepartures/"$stopid"?transporttypes=metro" 
Str=$(curl -H "Accept: text/javascript, text/html, application/xml, */* " $url 2>/dev/null  )
getTime $Str

echo "Place: $place"
if [ "$flag" == "--E" ]; then #Platform 1
	echo "Platform: 1"
	echo ${arr1[@]:0:3}  # take 3 elements from position 0
elif [ "$flag" == "--W" ]; then #Platform 2
	echo "Platform: 2"
	echo ${arr2[@]:0:3} 
else
	echo "Platform: 1"
	echo ${arr1[@]:0:3}  # take 3 elements from position 0
	echo "Platform: 2"
	echo ${arr2[@]:0:3} 
fi

