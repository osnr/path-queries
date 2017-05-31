#!/bin/bash -eux

# Run as user, not root.

# Meant to run on pyretic 2.2 clean VM (Ubuntu 13.04).
# Installs a bunch of apt dependencies, then OCaml and Frenetic.
# Sets up so you can run path query / eval scripts immediately afterward.

sudo tee /etc/apt/sources.list <<EOF

deb http://old-releases.ubuntu.com/ubuntu/  raring main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ raring-updates main restricted universe multiverse

deb http://old-releases.ubuntu.com/ubuntu/ raring-security main restricted universe multiverse
deb http://archive.canonical.com/ubuntu/ raring partner

EOF

sudo apt-get update
sudo apt-get --force-yes -y install unzip ragel

# TODO: Install pypy.

sudo pip install netaddr yappi fnss

wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
sudo sh ./opam_installer.sh /usr/local/bin 4.02.3

opam init --comp=4.02.3 --auto-setup -y

# Older frenetic doesn't have the right command line options.
# 3.4.1 is from March 2015 so think it's right.
opam install -y frenetic.3.4.1
ln -s /home/mininet/.opam/4.02.3/bin/frenetic ~/pyretic/frenetic

cd ~/pyretic
git checkout master
git pull
# Latest on path_queries branch.
git checkout 97ba3b46e53a4e2f8b000d5a87d4ff25b08cff95
# He forgot to add these files, so get them off master.
git checkout 3fe625bcce132740fc8732db359b12e13313bf02 -- pyretic/examples/stanford_data 

# Fix home folder hard-code.
sed -i.bak 's,/home/mina/,/home/mininet/,g' pyretic/evaluations/eval_compilation.py

# Avoid piping output to tee; stops a test lockup on first run.
sed -i.bak 's,| \$cap_cmd,,g' pyretic/evaluations/scripts/nsdi16/run*.sh

# Switch from pypy to Python for now.
tee pyretic/evaluations/scripts/nsdi16/init_settings.sh <<'EOF'
SCRIPT_LOG="pyretic/evaluations/log-evals.txt"
rm -f $SCRIPT_LOG
#PYCMD="/opt/pypy-2.4.0/bin/pypy"
PYCMD="python"
RUN_TIMEOUT="2.5h"
EOF

# Make folder for eval results.
mkdir -p pyretic/evaluations/evaluation_results/nsdi16

# At this point, can do
#
#     $ ./pyretic.py --use_pyretic -m i pyretic.examples.path_query --query=path_test_1 --fwding=static_fwding_chain_3_3
#
# then
#
#     $ ./mininet.sh --topo=chain,3,3
#     > pingall
#
# to run queries under interpreted-mode Pyretic.

# TODO: How to run queries under NetKAT? Still doesn't work...

# Or can do
#
#     $ sudo bash pyretic/evaluations/scripts/nsdi16/enterprise_opts.sh
