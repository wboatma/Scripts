#!/bin/bash

n=5
b=0
a=0
b_t=0
a_t=0
linenumber=0
fileptr=""

isnum(){
	if ! [ $1 -eq $1 2> /dev/null ] ;
	then 
		invalid ;
	fi
}

setvals(){
	if [ $1 -eq 1 ]
	then
		b=$n;
		a=$n;
		n=0;
	elif [ $1 -eq 2 ] || [ $1 -eq 3 ]
	then
		n=0;
	fi
}

testarg(){
	if [ ! -f $1 ] ;
	then
		echo "File not found: ($1)";
		exit 1;
	fi
	
	if ! [ $2 -eq $2 2> /dev/null ] ;
	then 
		invalid ;
	fi
}

help(){
 printf " \n\n";
	echo "* * *Line Tool --- Help Menu* * * * * * * * * * * * * * * * * * * * * * * * * * *";
 printf "* This is a tool to print a specific line, or groups of lines, from a file      *\n";
 printf "*                                                                               *\n";
	echo "* OPTIONS:                                                                      *";
 printf "*       -n <num> : Print the line and print the <num> lines before and after    *\n";
 printf "*                  By default -n is set to 5                                    *\n";
 printf "*       -a <num> : Print the line and print the <num> lines after               *\n";
 printf "*       -b <num> : Print the line and print the <num> lines before              *\n";
 printf "*       -h       : Print this menu                                              *\n";
 printf "*                                                                               *\n";
	echo "* USAGE:                                                                        *";
 printf "*       line [option] [<num>] <file> <line>                                     *\n";
 printf "*                                                                               *\n";
   echo "* EXAMPLE:                                                                      *";
 printf "*       line -n 4 file.txt 55                                                   *\n";
 printf "*             -n 4        - tells us to also print the 4 lines above and below  *\n";
 printf "*             file.txt    - the name of the file                                *\n";
 printf "*             55          - the line number in the file                         *\n";
   echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *";
   echo " ";
	exit 1
}

invalid(){
 printf " \n\n";
	echo "* * *INVALID USAGE* * * * * * * * * * * *";
	echo "*                                       *";
	echo "* line [option] [<num>] <file> <line>   *";
	echo "*                                       *";
	echo "* run 'line -h' to see the option menu  *";
	echo "* * * * * * * * * * * * * * * * * * * * *";
	echo "";
	exit 1;
}

opt="?"
while getopts "n:b:a:h" opt; 
do
	args=("$@");
	case "$opt" in
	   n) isnum $OPTARG;
	   	let "n=$OPTARG"; 
	   	setvals 1; break;;
		b) isnum $OPTARG;
	   	let "b=$OPTARG"; 
	   	let "n=0"; 
	   	setvals 2; break;;
		a) isnum $OPTARG;
	   	let "a=$OPTARG"; 
	   	let "n=0"; 
	   	setvals 3; break;;
		h) help ;;
		\?) echo "Invalid option: ${args[0]}"; 
			 echo "Please see help menu for usage."
			 exit 1;;
		:) echo "This option requires a number."
			exit 1;;
	esac
done

if [ "$opt" = "?" ]
then
	setvals 1;
fi

if [ $# -lt 2 ] ||  ! [ $2 -eq $2 2> /dev/null ] ;
then
	invalid ;
fi

while [[ $# -gt 0 ]] ;
do
   opt=$1;
   shift;
   if [ $# -eq 1 ]
   then
      testarg $opt $1 ;
      fileptr=$opt;
      linenumber=$1;
      shift;
   fi
done

if [ $a -gt 0 ]
then
	let "a_t=$linenumber+$a";
fi
if [ $b -gt 0 ]
then
	let "b_t=$linenumber-$b";
fi
if [ $b_t -lt 0 ] 
then
	let "b_t=0";
fi

echo "FILE: $fileptr";
i=0
while read line
do
	let "i++"
	if [ $b -gt 0 ]
	then
		if [ $i -ge $b_t ] &&  [ $i -lt $linenumber ]
		then
		   echo "$i:  $line"
		fi
	fi
	if [ $i -eq $linenumber ] 
	then
		echo "$i:  $line	   (******REQUESTED LINE******)"
	fi
	if [ $i -le $a_t ] && [ $i -gt $linenumber ]
	then
	   echo "$i:  $line"
	fi
done < $fileptr
