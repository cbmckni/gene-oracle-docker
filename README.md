# deep-gtex-docker

***Currently a non-funtional work-in-progress, but this should be enough to get you started.

## Building and pushing image

Once changes are made, build the image with ```docker build -t <IMG_NAME> .```

You can then test on your local machine with ```docker run ....```, or you can push to DockerHub to test the image on Nautilus.

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
 
## Testing on Nautilus

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

You can specify the number of GPUs and the image that will be pulled from DockerHub, among other things.

After kubectl is installed and configured, you can create the deployment using ```kubectl create -f deepgtex-pod.yaml```.

Check on your deployment using ```kubectl get pods```

If something fails, which it likely will, delete the deployment using ```kubectl delete -f deepgtex-pod.yaml```

If the pod starts sucessfully, you can access the pod through ```kubectl exec -it <POD_NAME> -- /bin/bash```

Data can be copied from your host machine with ```kubectl cp ....```

If everything works, make sure all of the file paths in [run.sh](https://github.com/cbmckni/deep-gtex-docker/blob/master/run.sh) are correct, then execute the script.
