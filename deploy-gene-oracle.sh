#!/bin/sh
echo "Instantiating pod..."
kubctl create -f gene-oracle-pod.yaml

echo "Copying subset data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/gene-oracle

echo "Copying data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/

