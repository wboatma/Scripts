#!/bin/bash

time=0;
sum_time=0;
avg_time=0;
loops=50;
site="$1";
dig="";
i=0;

if [ "$#" -eq 2 ];
then
    loops=$2;
fi

while [ "$i" -lt "$loops" ];
do
    time="$(dig $site | grep -o -E "[0-9]+ msec" | cut -d ' ' -f1)";
    let "sum_time += time";
    let "i++";
    #echo "$i --- $sum_time";
done

let "avg_time = sum_time / loops";

echo "Average DNS time for $site: $avg_time msec";
