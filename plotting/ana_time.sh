#!/bin/bash
for i in `echo 20 40 60 80 100 120 140 160`; do 
	for test in `echo igen_delauney waxman_03_03 waxman_02_04 waxman_04_02 waxman_05_015`; do
		for q in `echo tm congested_link path_loss slice ddos firewall`; do
		    for cnt in `seq 1 5`; do
				j=`echo $i, $test, $q, $cnt`
				grep -H 'total time' ~/pyretic/pyretic/evaluations/evaluation_results/nsdi16/${q}_${test}_${i}_fdd_${cnt}/stat.txt | awk -v var="$j" '{printf("%s, %f\n", var, $4)}' | sort -nk2 | tail -1
		    done  2>/dev/null
		done;
	done
done; 
