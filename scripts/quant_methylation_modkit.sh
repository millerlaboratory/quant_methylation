#!/bin/bash

#Update verion of modkit to partition based on HP tag.

WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit
REFERENCE=/n/users/sgibson/quant_methylation/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta
directory_list_file="/n/users/sgibson/1000g_methylation/directory_list.txt"

module load modkit/0.1.3

while IFS= read -r directory_name; do

mkdir -p "$WORKING_DIR/$directory_name"

#run modkit on each bam file
    for file in $WORKING_DIR/$directory_name/*.bam; do
    modkit pileup "$file" --cpg --ref $REFERENCE --ignore h --combine-strands --partition-tag HP "$WORKING_DIR/$directory_name/${file##*/}.cpg.bed"
    done
done < "$directory_list_file"
