#!/bin/bash -eux
set -o pipefail

# Run this after replication is done (if you get disconnected, then
# use screen -x or check the screenlog to keep track of the
# replication).

# Renders plots in VM, then copies them over to this machine.
gcloud compute ssh mininet@path-queries-replicator --zone asia-east1-a -- 'cd path-queries/plotting && ./gen_csv.sh && python path_queries_plot.py'

mkdir results
gcloud compute scp --zone asia-east1-a 'mininet@path-queries-replicator:~/path-queries/plotting/*.{png,csv}' results
