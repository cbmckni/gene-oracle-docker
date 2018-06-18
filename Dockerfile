FROM tensorflow/tensorflow:latest-gpu

WORKDIR /

RUN apt-get update
RUN apt-get install -y python-pip python-tk git nano

#Install packages
RUN pip install argparse halo scikit-learn numpy matplotlib msgpack scipy
RUN pip install update

#clone deep-gtex
RUN git clone https://github.com/ctargon/DeepGTEx 

WORKDIR DeepGTEx/

COPY run.sh ./run.sh

RUN /bin/bash
