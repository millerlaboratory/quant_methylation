#!/bin/bash

#Updated verion of modkit to partition based on HP tag.

INPUT_DIR=/n/1000g/align-card-2.24-hg38
WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/v0.1.11
REFERENCE=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta

module load modkit/0.1.11

cd $WORKING_DIR

#list all of the bam files
files=$(find $INPUT_DIR -type f -name "*_PMDV_FINAL.haplotagged.bam")

#run modkit on each bam file
for file in $files; do
    modkit pileup "$file" --cpg --ref $REFERENCE --ignore h --combine-strands --partition-tag HP "$WORKING_DIR/${file##*/}" --log-filepath "$WORKING_DIR/${file##*/}/pileup.log" --prefix "${file##*/}.cpg"
done
