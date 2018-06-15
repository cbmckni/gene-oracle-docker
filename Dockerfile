FROM ubuntu

#configure non-interactive tzdata
RUN apt-get update && apt-get install -y tzdata
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

#install software
RUN apt-get install -y python3-pip python3-venv git python3-tk
RUN pip3 install virtualenv

#create env 
RUN python3 -m venv gtex
RUN . gtex/bin/activate

#Install packages
RUN pip3 install --upgrade tensorflow argparse halo scikit-learn numpy matplotlib \
 msgpack scipy

#clone deep-gtex
RUN git clone https://github.com/ctargon/DeepGTEx 

WORKDIR DeepGTEx/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

