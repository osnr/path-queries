#!/bin/bash -eux
gcloud compute instances create $1 --image pyretic-clean
gcloud compute scp pyretic-clean-to-path-queries.sh mininet@$1:~
gcloud compute ssh mininet@$1 -- './pyretic-clean-to-path-queries.sh'
