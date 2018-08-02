#!/bin/sh

#Purpose: Will wait for input data directory to stabilize, then run gene-oracle
#Run from outside script using kubectl exec ....

#Command line args:
# $1 - set? Not sure what this is, needs attention
# $2 - input data directory

dataDir="/gene-oracle/data"

#Clone gene-oracle
git clone https://github.com/ctargon/gene-oracle 

last=0
current=1

#Wait for input data to finish downloading
echo "Checking if data is stable..."
while [ "$last" != "$current" ]; do
   last=$current
   current=$(find "${dataDir}" -exec stat -c "%Y" \{\} \; | sort -n | tail -1)
   echo "Waiting for data download to finish..."
   sleep 4
done
echo "data directory is now stable..."

#run gene-oracle script
echo "Running gene-oracle..." 
mv ${dataDir}/command.sh /gene-oracle/gene-oracle
cd gene-oracle
sh ./command.sh





