#!/bin/sh

#Purpose: Will wait for data directories to stabilize, then run gene-oracle
#Run from outside script using kubectl exec ....

#Command line args:
# $1 - set? Not sure what this is, needs attention
# $2 - input data directory

dataDir="$2"

# check whether directories exist
test -d "${dataDir}" || exit 1

last=0
current=1

#Wait for input data to finish downloading
echo "Checking if data is stable..."
while [ "$last" != "$current" ]; do
   last=$current
   current=$(find "${dataDir}" -exec stat -c "%Y" \{\} \; | sort -n | tail -1)
   echo "Waiting for data download to finish..."
   sleep 4
done
echo "data directory is now stable..."


# run gene oracle
#python scripts/gene-oracle.py  \
#	--dataset ./$2/float_data/gtex_gct_data_float_v7.npy \
#	--gene_list ./$2/gene_lists/gtex_gene_list_v7.npy \
#	--sample_json ./$2/class_counts/gtex_tissue_count_v7.json \
#	--config ./models/net_config.json \
#	--subset_list ./$2/hallmark_experiments.txt \
#	--set $1 \
#	--num_genes 36 \
#	--log_dir ./logs/$1


# run gene oracle based on a specific subset - JUST FOR TESTING
python scripts/classify.py \
 --dataset ./$2/gtex_gct_data_float_v7.npy \
 --gene_list ./$2/gtex_gene_list_v7.npy \
 --sample_json ./$2/gtex_tissue_count_v7.json \
 --subset_list ./$2/hallmark_experiments.txt \
 --config ./models/net_config.json \
 --out_file ./$2/hallmark_classify_kfold10.log
