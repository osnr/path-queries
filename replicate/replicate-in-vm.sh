#!/bin/bash -eux
set -o pipefail

# Run this script after running vm-from-image.sh.

# Copy the scripts in this repo into the VM, then run the replication.

# ssh will ask for password:
# mininet

gcloud compute scp --recurse .. mininet@path-queries-replicator:~/path-queries --zone asia-east1-a
gcloud compute ssh mininet@path-queries-replicator --zone asia-east1-a -- 'cd path-queries && screen -L -S rep-tests sudo bash rep_tests.sh'
