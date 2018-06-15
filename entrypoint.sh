#!/bin/sh

#run gtex command
python3 scripts/classify.py --dataset /data/float_data/gtex_gct_data_float_v7.npy \
 --gene_list /data/gene_lists/gtex_gene_list_v7.npy \
 --sample_json /data/class_counts/gtex_tissue_count_v7.json \  
 --subset_list ./subsets/hallmark_experiments.txt \
 --config ./models/net_config.json \
 --out_file ./logs/hallmark_classify_kfold10.log
