# gene-oracle-docker

***Currently a funtional work-in-progress

This is a dockerized version of [gene-oracle](https://github.com/ctargon/gene-oracle), a deep learning algorithm built using Tensorflow. 

**Funtionality**

This software allows the user to create a pod that creates *N* gene-oracle containers on a Kubernertes cluster. It creates a framework for the pod, starts a pod based on that framework, copies input data into the pod, then runs gene-oracle inside the pod once data is done copying. The user can then run another script to pull log data from each container to their local machine.

Assume *N* will be the number of sets in the experiment.

# Building and pushing image

Since this image utilizes GPUs, you will need to install [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) if you want to run the image on your local machine. You can still build and push the image with regular docker commands.

Once changes are made, build the image with ```docker build -t <IMG_NAME> .```

If you plan on running locally, build the GPU image with ```nvidia-docker build -t <IMG_NAME> .```

You can then test on your local machine with ```nvidia-docker run ....```, or you can push to DockerHub to test the image on Nautilus.

**Pushing to DockerHub**

Build the image, then run ```docker images``` to see your image like so:
```
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
gene-oracle                 latest              a88adcfb02de        3 hours ago         1.24GB
...
```

Tag the image with ```docker tag <IMG_ID> <HUB_USER>/<REPO>:<VERSION>```.
 - ex: ```docker tag a88adcfb02de cbmckni/gene-oracle:latest```
 
Push with ```docker push <HUB_USER>/<REPO>```.
 - ex: ```docker push cbmckni/gene-oracle```

[Source](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)

Once an image is on DockerHub, it can be pulled. If you do not use the default image, you must change the line in *deploy-gene-oracle.sh* to pull your image:
```
apiVersion: v1
kind: Pod
metadata:
  name: gene-oracle
spec:
  containers:
  - name: gene-oracle-container-1
    image: <YOUR_IMAGE>
    imagePullPolicy: Always
    resources:
      limits:
        nvidia.com/gpu: 1
...
```
 
# Running on Nautilus

This can be run on any kubernertes cluster, but these instructions are specifically for the [Nautilus](https://nautilus.optiputer.net/) system.

##Configuration

After installing [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) on your local machine, it must be configured to the Nautilus system. 

To do this, log in to [Nautilus](https://nautilus.optiputer.net/) and click the "Get config" link at the top right taskbar. A file named "config" will be downloaded, which will need to be put in the ```~/.kube/``` directory on your local machine. 

Test with ```kubectl config view''' [Source](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration)

**Pod Framework**

The Kubernertes pod that will be deployed is outlined through a framework in .yaml format. This framework is automatically generated through the script *deploy-gene-oracle.sh*.

You can change the pod's framework to suit your needs by adding to the script.
 
The number of GPUs and the image that will be pulled from DockerHub can be specified, among other things.

*Ex:* To run the pod on a specific node/gpu(ex. a FIONA node), add the ```nodeSelector``` attribute to the yaml file.
 - Examples of this can be found [here](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)

After kubectl is installed and configured, you can run *deploy-gene-oracle.sh* to deploy your pod.


##Deployment

**Pre-deployment**

The user will create a folder of input data, which is located in the parent directory of the gene-oracle-docker repo. So ```$(pwd)/..``` must point to the folder where the input folder is located. Name each folder "data".

**Usage**

Once all input data is in the folder "data", run the script. *Ex.* ```./deploy-gene-oracle.sh 3 $(pwd)/..``` creates a 3 container pod with input data located in the parent directory.

If you are authenticated correctly and input data is correct, the script should run without error. The terminal will start printing output from each container as it runs gene-oracle.

**Post-deployment**

Check on your deployment using ```kubectl get pods```

Once gene-oracle has finished, you can copy the log files back to your machine with ```kubectl cp ...```, or run the script *get-logs.sh*. 

*Ex.* ```./get-logs.sh 3``` to pull logs from a 3-container pod.


##Deletion

Delete the deployment using ```kubectl delete pod gene-oracle``` 

**Do not leave an idle deployment running for too long!**
