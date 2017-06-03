#!/bin/bash -eux
set -o pipefail

# Run this script after running vm-from-image.sh.

# Clone our final scripts into the VM, then run the replication.

# ssh will ask for password:
# mininet

gcloud compute ssh mininet@path-queries-replicator --zone asia-east1-a -- 'git clone https://github.com/osnr/path-queries && cd path-queries && screen -L -S rep-tests sudo bash rep_tests.sh'
