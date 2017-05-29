# should ssh-copy-id so doesn't need password.

from __future__ import print_function
import sys
import tempfile
import itertools
from subprocess import check_output, PIPE
import matplotlib.pyplot as plt

if len(sys.argv) != 2:
    print('Usage:', sys.argv[0], 'MACHINE')
    exit(1)

machine = sys.argv[1]
# resultsdir = tempfile.mkdtemp()
# print('Copying results to', resultsdir)

# FIXME: copy results from machine to here.
# check_call(['scp', '-r', machine + ':~/pyretic/pyretic/evaluations/evaluation_results/nsdi16', resultsdir], stdout=PIPE, stderr=PIPE)

# sizes = [20, 40, 60, 80, 100, 120, 140, 160]
# tests = ['igen_delauney', 'waxman_03_03', 'waxman_02_04', 'waxman_04_02', 'waxman_05_015']
# queries = ['tm', 'congested_link', 'path_loss', 'slice', 'ddos', 'firewall']

# for i, test, query in itertools.product(sizes, tests, queries):
    

def run_on_machine(command):
    results = check_output(['ssh', machine,
                            'cd ~/pyretic/pyretic/evaluations/evaluation_results/nsdi16; ' + command])
    return [result.split(' ') for result in results.splitlines()]

plt.xlabel('Number of nodes')

getcompiletimes = r'''for i in `echo 20 40 60 80 100 120 140 160`; do for test in `echo igen_delauney waxman_03_03 waxman_02_04 waxman_04_02 waxman_05_015`; do for query in `echo tm congested_link path_loss slice ddos firewall`; do grep -H 'total time' ${query}_${test}_${i}_fdd_1/stat.txt | awk '{print $1 " " $4}' | sort -nk2 | tail -1; done ; done | awk -v prefix=$i '{total += $2; count++} END { print prefix " " total/count " " count }'  ; done 2>/dev/null'''
compiletimes = run_on_machine(getcompiletimes)
sizes, avgcompiletimes, counts = zip(*compiletimes)
plt.plot(sizes, avgcompiletimes, '-o', label='Avg compile time (s)')

# get rule count for in_table, averaged
getrulecounts = r'''for i in `echo 20 40 60 80 100 120 140 160`; do for test in `echo igen_delauney waxman_03_03 waxman_02_04 waxman_04_02 waxman_05_015`; do for query in `echo tm congested_link path_loss slice ddos firewall`; do grep -H 'in_table' ${query}_${test}_${i}_fdd_1/stat.txt | grep '))' | sed '/^S/d' | awk '{print $1 " " $3}' | sed 's/.$//' | awk '{ total += $2 ; count++ } END { print $1 " " total " " count }' ; done ; done  | sed '/^\s\s$/d' | awk -v prefix=$i '{ total += $2; count++ } END { print prefix " " total/count }' ; done 2>/dev/null'''
rulecounts = run_on_machine(getrulecounts)
sizes, avgrulecounts = zip(*rulecounts)
plt.plot(sizes, avgrulecounts, '-o', label='Avg rule count')
plt.legend()
plt.title('Scalability trends on synthetic ISP topologies (%s)' % (machine))
plt.show()

# get state count, averaged
getstatecounts = r'''for i in `echo 20 40 60 80 100 120 140 160`; do for test in `echo igen_delauney waxman_03_03 waxman_02_04 waxman_04_02 waxman_05_015`; do for query in `echo tm congested_link path_loss slice ddos firewall`; do val=`grep -H 'state count' ${query}_${test}_${i}_fdd_1/stat.txt | awk '{printf("%s ", $4)}' ` ; python -c "import math; sum=reduce(lambda acc,x: acc + int(math.ceil(math.log(int(x),2))), \"${val}\".split(), 0); print sum" ; done ; done | awk -v prefix=$i ' { if ( $1 > 0 ) { total += $1; count++ } } END { print prefix " " total/count " " count }' ; done 2>/dev/null'''
statecounts = run_on_machine(getstatecounts)

