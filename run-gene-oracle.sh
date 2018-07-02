#!/bin/sh

#Purpose: Will wait for data directories to stabilize, then run gene-oracle
#Run from outside script using kubectl exec ....

#Command line args:
# $1 - subset data directory
# $2 - data directory

# run gene oracle based on a specific subset
#python scripts/classify.py --dataset /data/float_data/gtex_gct_data_float_v7.npy \
# --gene_list /data/gene_lists/gtex_gene_list_v7.npy \
# --sample_json /data/class_counts/gtex_tissue_count_v7.json \  
# --subset_list /data/hallmark_experiments.txt \
# --config ./models/net_config.json \
# --out_file /data/logs/hallmark_classify_kfold10.log

subsetDir="$1"
dataDir="$2"

# check whether directories exist
test -d "${subsetDir}" || exit 1
test -d "${dataDir}" || exit 1

last=0
current=1

while [ "$last" != "$current" ]; do
   last=$current
   current=$(find "${subsetDir}" -exec stat -c "%Y" \{\} \; | sort -n | tail -1)
   sleep 10
done
echo "subset directory is now stable..."

last=0
current=1

while [ "$last" != "$current" ]; do
   last=$current
   current=$(find "${subsetDir}" -exec stat -c "%Y" \{\} \; | sort -n | tail -1)
   sleep 10
done
echo "data directory is now stable..."

echo "Running gene oracle algorithm on subset: "
echo $1

python scripts/gene-oracle.py  \
	--dataset /data/float_data/gtex_gct_data_float_v7.npy \
	--gene_list /data/gene_lists/gtex_gene_list_v7.npy \
	--sample_json /data/class_counts/gtex_tissue_count_v7.json \
	--config ./models/net_config.json \
	--subset_list ./subsets/hallmark_experiments.txt \
	--set $1 \
	--num_genes 36 \
	--log_dir ./logs/$1

