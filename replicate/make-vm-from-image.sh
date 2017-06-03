#!/bin/bash -eux
set -o pipefail

# This script is meant to be run by a replicator.
# It should be run right after setting up gcloud:
# https://cloud.google.com/sdk/gcloud/

# Take our public myimage tarball, which is a ready-made disk image of
# the Pyretic 2.2 VM
# https://bitbucket.org/reich/pyretic-vms/downloads/Pyretic-0.2.2-amd64.zip
# plus extra dependencies installed for path query tests (especially
# Frenetic 3.4.1) and subsequent analysis.

# The disk image needs to be imported into your gcloud account before
# you can make instances based on it, so do that now. (This only needs
# to happen once; if this command fails, we ignore it and assume it's
# because you already imported the image.)

gcloud compute images create pyretic-path-queries --source-uri gs://path-queries/myimage.tar.gz || true

# This is a high-mem 8-core image, so will probably fill the entire
# zone CPU quota for your account, so pick an odd zone for now as a
# hack.

gcloud compute instances create path-queries-replicator --image pyretic-path-queries --zone asia-east1-a --machine-type n1-highmem-8

