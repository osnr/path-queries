#!/bin/bash

stat_root="~/pyretic/pyretic/evaluation/evaluation_results/nsdi16/"
network="stanford"

# Print max in table rule counts
for q in `echo cache fdd partition preddecomp`; do
	for cnt in `seq 1 5`; do
		stat_path=${stat_root}${network}_${q}_${cnt}/stat.txt
		j=`echo $q,$cnt,max_in`
    	grep -H 'in_table' $stat_path | grep '))' | awk '{print $3}' | sed 's/.$//' | awk -v val="$j" '{ total += $1 } END { print val "," total }'
	done
done

# Print max out table rule counts
for q in `echo cache fdd partition preddecomp`; do
	for cnt in `seq 1 5`; do
		stat_path=${stat_root}${network}_${q}_${cnt}/stat.txt
		j=`echo $q,$cnt,max_out`
    	grep -H 'out_table' $stat_path | grep '))' | awk '{print $3}' | sed 's/.$//' | awk -v val="$j" '{ total += $1 } END { print val "," total }'
	done
done

# Print compilation times
for q in `echo cache fdd partition preddecomp`; do
	for cnt in `seq 1 5`; do
		stat_path=${stat_root}${network}_${q}_${cnt}/stat.txt
		j=`echo $q,$cnt,comp_time`
		grep -H 'total time' $stat_path | awk -v var="$j" '{printf("%s, %f\n", var, $4)}' | sort -nk2 | tail -1
	done
done

# Print state counts
for q in `echo cache fdd partition preddecomp`; do
	for cnt in `seq 1 5`; do
		stat_path=${stat_root}${network}_${q}_${cnt}/stat.txt
		j=`echo $q,$cnt,state_count`
		val=`grep -H 'state count' $stat_path | awk '{printf("%s ", $4)'}`;
		python2.7 -c "import math; sum=reduce(lambda acc, x: acc + int(math.ceil(math.log(int(x),2))), \"${val}\".split(), 0); print(\"$j,\", sum)";
		
	done
done
