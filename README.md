# gene-oracle-docker

***Currently a funtional work-in-progress

This is a dockerized version of [gene-oracle](https://github.com/ctargon/gene-oracle), a deep learning algorithm built using Tensorflow. 

## Building and pushing image

Since this image utilizes GPUs, you will need to install [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) if you want to run the image on your local machine. You can still build and push the image with regular docker commands.

Once changes are made, build the image with ```docker build -t <IMG_NAME> .```

If you plan on running locally, build the GPU image with ```nvidia-docker build -t <IMG_NAME> .```

You can then test on your local machine with ```nvidia-docker run ....```, or you can push to DockerHub to test the image on Nautilus.

**Pushing to DockerHub**

Build the image, then run ```docker images``` to see your image like so:
```
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
gene-oracle                 latest              a88adcfb02de        3 hours ago         1.24GB
gtex                        latest              a88adcfb02de        3 hours ago         1.24GB
...
```

Tag the image with ```docker tag <IMG_ID> <HUB_USER>/<REPO>:<VERSION>```.
 - ex: ```docker tag a88adcfb02de cbmckni/gene-oracle:latest```
 
Push with ```docker push <HUB_USER>/<REPO>```.
 - ex: ```docker push cbmckni/gene-oracle```

[Source](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)
 
## Testing on Nautilus

**Configuration**

After installing [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) on your local machine, it must be configured to the Nautilus system. 

To do this, log in to [Nautilus](https://nautilus.optiputer.net/) and click the "Get config" link at the top right taskbar. A file named "config" will be downloaded, which will need to be put in the ```~/.kube/``` directory on your local machine. 

Test with ```kubectl config view''' [Source](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration)

**Deployment**

Once an image is on DockerHub, it can be pulled. In the file [gene-oracle-pod.yaml](https://github.com/cbmckni/gene-oracle-docker/blob/master/gene-oracle-pod.yaml):
```
apiVersion: v1
kind: Pod
metadata:
  name: gene-oracle
spec:
  containers:
  - name: gene-oracle-container
    image: docker.io/cbmckni/gene-oracle
    imagePullPolicy: Always
    resources:
      limits:
        nvidia.com/gpu: 1
```

The number of GPUs and the image that will be pulled from DockerHub can be specified, among other things.

To run the pod on a specific node/gpu(ex. a FIONA gpu), add the ```nodeSelector``` attribute to the yaml file.
 - Examples of this can be found [here](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)

After kubectl is installed and configured, you can create the deployment using ```kubectl create -f gene-oracle-pod.yaml```. 

**Usage**

Check on your deployment using ```kubectl get pods```

If the pod starts sucessfully, you can access the pod through ```kubectl exec -it <POD_NAME> -- /bin/bash``` [Source](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

Data can be copied to and from your host machine with ```kubectl cp ....``` [Source](https://medium.com/@nnilesh7756/copy-directories-and-files-to-and-from-kubernetes-container-pod-19612fa74660)

If everything works, make sure all of the file paths in [run.sh](https://github.com/cbmckni/deep-gtex-docker/blob/master/run.sh) are correct, then execute the script.

**Deletion**

Delete the deployment using ```kubectl delete -f deepgtex-pod.yaml``` 

**Do not leave an idle deployment running for too long!**
