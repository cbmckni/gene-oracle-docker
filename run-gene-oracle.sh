#!/bin/sh

# run gene oracle based on a specific subset
#python scripts/classify.py --dataset /data/float_data/gtex_gct_data_float_v7.npy \
# --gene_list /data/gene_lists/gtex_gene_list_v7.npy \
# --sample_json /data/class_counts/gtex_tissue_count_v7.json \  
# --subset_list /data/hallmark_experiments.txt \
# --config ./models/net_config.json \
# --out_file /data/logs/hallmark_classify_kfold10.log

python scripts/gene-oracle.py  \
	--dataset /data/float_data/gtex_gct_data_float_v7.npy \
	--gene_list /data/gene_lists/gtex_gene_list_v7.npy \
	--sample_json /data/class_counts/gtex_tissue_count_v7.json \
	--config ./models/net_config.json \
	--subset_list ./subsets/hallmark_experiments.txt \
	--set hallmark_hedgehog_signaling \
	--num_genes 36 \
	--log_dir ./logs/hallmark_hedgehog_signaling

