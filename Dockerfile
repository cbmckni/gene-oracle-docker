FROM tensorflow/tensorflow:latest-gpu
MAINTAINER Cole McKnight <cbmckni@clemson.edu> Colin Targonski <ctargon@clemson.edu>

WORKDIR /

#Install initial software
RUN apt-get update
RUN apt-get install -y python-pip python-tk git nano

#Install packages
RUN pip install argparse halo scikit-learn numpy matplotlib msgpack scipy
RUN pip install update

#Clone deep-gtex
RUN git clone https://github.com/ctargon/gene-oracle 

WORKDIR gene-oracle/

#Copy entrypoint script 
COPY run.sh ./run.sh
RUN chmod +x run.sh

ENTRYPOINT ["run.sh"]
