#!/bin/sh

#Purpose: Instantiate a gene-oracle pod with a given number of containers.

#Command line arguments
# $1 - number of containers

mkdir -p ../logs

#Copy logs from each container to local machine
for i in $(seq 1 $1); do
    echo "Getting log...$i"
    kubectl cp deepgtex-prp/gene-oracle:/gene-oracle -c gene-oracle-container-$i ../logs &
    sleep 1
done



