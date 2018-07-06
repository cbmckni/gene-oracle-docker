#!/bin/sh

#Purpose: Instantiate a gene-oracle pod with a given number of containers.

#Command line arguments
# $1 - number of containers
# $2 - input data dir - input data folders must be named "data-<experiment_number>". See README for more info.

#Generate beginning of pod file
cat > ./gene-oracle-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: gene-oracle
spec:
  containers:
EOF

#Add containers to end of file
for i in $(seq 1 $1); do
    echo "  - name: gene-oracle-container-$i" >> ./gene-oracle-pod.yaml
    echo "    image: docker.io/cbmckni/gene-oracle" >> ./gene-oracle-pod.yaml
    echo "    imagePullPolicy: Always" >> ./gene-oracle-pod.yaml
    echo "    resources:" >> ./gene-oracle-pod.yaml
    echo "      limits:" >> ./gene-oracle-pod.yaml
    echo "        nvidia.com/gpu: 1" >> ./gene-oracle-pod.yaml
done

echo "Generated pod framework:"
cat ./gene-oracle-pod.yaml
sleep 5

echo "Instantiating pod..."
kubectl create -f gene-oracle-pod.yaml

sleep 15
kubectl get pods

echo "IF YOU DO NOT SEE YOUR POD NAME, KILL THIS SCRIPT"

#Add containers to end of file
for i in $(seq 1 $1); do
    echo "Copying data...$i"
    kubectl cp $2/data-$i deepgtex-prp/gene-oracle:/gene-oracle -c gene-oracle-container-$i &
#    echo "Starting gene-oracle...$i"
#    kubectl exec gene-oracle -c gene-oracle-container-$i -- ./run-gene-oracle set-$i data-$i &
done




