# gene-oracle-docker

***Currently a funtional work-in-progress

I decided to write up this temporary read-me for testing purposes. I will update the main file once all the changes on your side are made. Needs will be outlined below....

# Funtionality

This branch creates a pod that creates N gene-oracle containers on a Kubernertes cluster. It creates a framework, starts a pod based on that framework, copies input data into the pod, then runs gene-oracle inside the pod once data is done copying.

I assume N will be the number of sets in the experiment.

# Instructions

At this point, the user will create N folders of input data, all of which are located in the directory "above" the gene-oracle-docker repo. So $(pwd)/.. must point to the folder where the input folders are located. Name each folder "data-1, data-2, ...., data-N" for each container you want.

Once all input data is in each folder, run the script. Ex. ```./deploy-gene-oracle.sh 3 $(pwd)/..``` creates a 3 container pod with input data located in the parent directory.

If you are authenticated correctly and input data is correct, all should work. The terminal will start printing output from each container as it runs gene-oracle.

You can copy the log files back to your machine with kubectl cp.

# TODO

More testing is needed. 

Look at the way input data is passed, correct it to suit your needs. 

Maybe add to the script or create a new one to pull the logs from each container back to your machine.

Whatever else that will help you run your experiment....
