#!/bin/bash -eux
gcloud compute instances create $1 --image pyretic-clean
gcloud compute scp pyretic-clean-to-path-queries.sh mininet@$1:~

# Start the dep install script in screen, so we don't have to babysit it.
gcloud compute ssh mininet@$1 -- 'screen -L -S to-path-queries "/home/mininet/pyretic-clean-to-path-queries.sh"'
