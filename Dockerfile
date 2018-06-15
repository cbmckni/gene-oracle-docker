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

#run gtex command
RUN python3 scripts/classify.py -h

#RUN python3 scripts/classify.py --dataset ./data/float_data/gtex_gct_data_float_v7.npy \
# --gene_list ./data/gene_lists/gtex_gene_list_v7.npy \
# --sample_json ./data/class_counts/gtex_tissue_count_v7.json \  
# --subset_list ./subsets/hallmark_experiments.txt \
# --config ./models/net_config.json \
# --out_file ./logs/hallmark_classify_kfold10.log

