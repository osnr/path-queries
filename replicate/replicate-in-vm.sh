#!/bin/bash -eux
set -o pipefail

# Run this script after running vm-from-image.sh.

# Copy the scripts in this repo into the VM, then run the replication.

# ssh will ask for password twice:
# mininet

cd ..
tar czf - * | gcloud compute ssh mininet@path-queries-replicator --zone asia-east1-a -- 'mkdir path-queries && cd path-queries && tar xvzf -'
cd -

gcloud compute ssh mininet@path-queries-replicator --zone asia-east1-a -- 'cd path-queries && screen -L -S rep-tests sudo bash test/rep_tests.sh'

# Output log (even if you detach) will be in ~/path-queries/screenlog.0 on the VM.
# (NOT ~/screenlog.0!)
