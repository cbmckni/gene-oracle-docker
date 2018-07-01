#!/bin/sh
echo "Instantiating pod..."
kubctl create -f gene-oracle-pod.yaml

sleep 5
kubectl get pods

echo "IF YOU DO NOT SEE YOUR POD NAME, KILL THIS SCRIPT"

echo "Copying subset data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/gene-oracle

echo "Copying data..."
kubectl cp /home/eceftl2/workspace/SciDAS/gene-oracle/data/ deepgtex-prp/gene-oracle:/

