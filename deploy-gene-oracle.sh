#!/bin/sh
echo "Instantiating pod..."
kubctl create -f gene-oracle-pod.yaml

echo "Copying data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/

echo "Copying subset data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/gene-oracle