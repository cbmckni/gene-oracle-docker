FROM tensorflow/tensorflow:latest-gpu
MAINTAINER Cole McKnight <cbmckni@clemson.edu> Colin Targonski <ctargon@clemson.edu>

WORKDIR /

#Make input data directories
RUN mkdir data subsets

#Install initial software
RUN apt-get update
RUN apt-get install -y python-pip python-tk git nano vim

#Install packages
RUN pip install argparse halo scikit-learn numpy matplotlib msgpack scipy
RUN pip install update

#Clone deep-gtex
RUN git clone https://github.com/ctargon/gene-oracle #try again

WORKDIR gene-oracle/

#Copy entrypoint script 
COPY run-gene-oracle.sh ./run-gene-oracle.sh
RUN chmod +x run-gene-oracle.sh

RUN /bin/bash
