#!/bin/bash -eux
set -o pipefail

# Run this script after running make-vm-from-image.sh / setting up VM
# by hand from the image. Assumes pyretic, frenetic, etc all work and
# the tests can run right away.

# This script copies the repo it's in into the VM, then runs
# test/rep_tests.sh inside the VM.

# ssh will ask for password twice:
# mininet

REPO=$(git rev-parse --show-toplevel)
scp -r "$REPO" mininet@$1:~/path-queries

ssh -t mininet@$1 'cd path-queries && screen -L -S rep-tests sudo bash test/rep_tests.sh'

# Output log (even if you detach) will be in ~/path-queries/screenlog.0 on the VM.
# (NOT ~/screenlog.0!)
