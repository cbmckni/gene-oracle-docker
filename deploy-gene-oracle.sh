#!/bin/sh

#Purpose: Instantiate a gene-oracle pod with a given number of containers.

#Command line arguments
# $1 - number of containers
# $2 - subset data dir - subset data files must be named "subset-<experiment_number>"
# $3 - input data dir - data files must be named "data-<experiment_number>"

#Generate beginning of pod file
cat > ./gene-oracle-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: gene-oracle
spec:
  containers:
EOF
}
#Add containers to end of file
for i in "seq 0 $1"; do
    echo "  - name: gene-oracle-container-$i" >> ./gene-oracle-pod.yaml
    echo "    image: docker.io/cbmckni/gene-oracle" >> ./gene-oracle-pod.yaml
    echo "    imagePullPolicy: Always" >> ./gene-oracle-pod.yaml
    echo "      limits:" >> ./gene-oracle-pod.yaml
    echo "        nvidia.com/gpu: 1" >> ./gene-oracle-pod.yaml
done

echo "Instantiating pod..."
kubectl create -f gene-oracle-pod.yaml

sleep 15
kubectl get pods

echo "IF YOU DO NOT SEE YOUR POD NAME, KILL THIS SCRIPT"

#Add containers to end of file
for i in "seq 0 $1"; do
    echo "Copying subset data..."
    kubectl cp $2/subset-$i deepgtex-prp/gene-oracle:/gene-oracle -c gene-oracle-container-$i
    echo "Copying data..."
    kubectl cp $3/data-$i deepgtex-prp/gene-oracle:/gene-oracle -c gene-oracle-container-$i
done




