#!/bin/bash -eux
set -o pipefail

# This script is meant to be run by a replicator.
# It should be run right after setting up gcloud:
# https://cloud.google.com/sdk/gcloud/
# It should be the first script you run.

# Take our public myimage tarball, which was originally based on this
# Pyretic 0.2.2 VM on their website:
# https://bitbucket.org/reich/pyretic-vms/downloads/Pyretic-0.2.2-amd64.zip
#
# We installed extra dependencies for path query tests (especially
# Frenetic 3.4.1) and subsequent analysis.
#
# The disk image needs to be imported into your gcloud account before
# you can make instances based on it, so we do that now. (This only
# needs to happen once; if this command fails, we ignore it and assume
# it's because you already imported the image.)

gcloud compute images create pyretic-path-queries --source-uri gs://path-queries/myimage.tar.gz || true

# We're making a high-mem 8-core instance, so will probably fill the
# entire zone CPU quota for your account, so pick an odd zone for now
# as a hack.

gcloud compute instances create path-queries-replicator --image pyretic-path-queries --zone asia-east1-a --machine-type n1-highmem-8

