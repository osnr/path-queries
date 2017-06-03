#!/bin/bash -eux

# Will ask for password once to copy ssh key, then should work.

gcloud compute instances create $1 --image pyretic-clean
IP=`gcloud compute instances describe $1 --format="value(networkInterfaces[0].accessConfigs[0].natIP)"`

sleep 20 # Give it some time to boot.

# Save us from having to auth from now on.
ssh-copy-id mininet@$IP

scp pyretic-clean-to-path-queries.sh mininet@$IP:~

# Start the dep install script in screen, so we don't have to babysit it.
ssh -t mininet@$IP 'screen -L -S to-path-queries "/home/mininet/pyretic-clean-to-path-queries.sh"'
