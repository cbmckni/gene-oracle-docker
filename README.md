# deep-gtex-docker

***Currently a funtional work-in-progress

This is a dockerized version of [DeepGTEx](https://github.com/ctargon/DeepGTEx), a TensorFlow deep learning algorithm. 

## Building and pushing image

Since this image utilizes GPUs, you will need to install [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) if you want to run the image on your local machine. You can still build and push the image with regular docker commands.

Once changes are made, build the image with ```(nvidia-docker OR docker) build -t <IMG_NAME> .```

You can then test on your local machine with ```nvidia-docker run ....```, or you can push to DockerHub to test the image on Nautilus.

**Pushing to DockerHub**

Build the image, then run ```docker images``` to see your image like so:
```
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
cbmckni/deep-gtex           latest              a88adcfb02de        3 hours ago         1.24GB
gtex                        latest              a88adcfb02de        3 hours ago         1.24GB
...
```

Tag the image with ```docker tag <IMG_ID> <HUB_USER>/<REPO>:<VERSION>```.
 - ex: ```docker tag a88adcfb02de cbmckni/deep-gtex:latest```
 
Push with ```docker push <HUB_USER>/<REPO>```.
 - ex: ```docker push cbmckni/deep-gtex```

[Source](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)
 
## Testing on Nautilus

**Deployment**

Once an image is on DockerHub, it can be pulled. In the file [deepgtex-pod.yaml](https://github.com/cbmckni/deep-gtex-docker/blob/master/deepgtex-pod.yaml):
```
apiVersion: v1
kind: Pod
metadata:
  name: deep-gtex
spec:
  containers:
  - name: deep-gtex-container
    image: docker.io/cbmckni/deep-gtex
    imagePullPolicy: Always
    resources:
      limits:
        nvidia.com/gpu: 1
```

The number of GPUs and the image that will be pulled from DockerHub can be specified, among other things.

After kubectl is installed and configured, you can create the deployment using ```kubectl create -f deepgtex-pod.yaml```. 

**Usage**

Check on your deployment using ```kubectl get pods```

If the pod starts sucessfully, you can access the pod through ```kubectl exec -it <POD_NAME> -- /bin/bash``` [Source](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

Data can be copied to and from your host machine with ```kubectl cp ....``` [Source](https://medium.com/@nnilesh7756/copy-directories-and-files-to-and-from-kubernetes-container-pod-19612fa74660)

If everything works, make sure all of the file paths in [run.sh](https://github.com/cbmckni/deep-gtex-docker/blob/master/run.sh) are correct, then execute the script.

**Deletion**

Delete the deployment using ```kubectl delete -f deepgtex-pod.yaml``` 

**Do not leave an idle deployment running for too long!**
