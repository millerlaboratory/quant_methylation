#!/bin/bash

#Updated verion of modkit to partition based on HP tag.

INPUT_DIR=$1
WORKING_DIR=$2
REFERENCE=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta

module load modkit/0.1.11

cd $WORKING_DIR

#list all of the bam files
files=$(find $INPUT_DIR -type f -name "*_PMDV_FINAL.haplotagged.bam")

#run modkit on each bam file
for file in $files; do
    dir_name=$(basename "${file}" | cut -d '-' -f1)
    modkit pileup "$file" --cpg --ref $REFERENCE -t 40 --ignore h --combine-strands --partition-tag HP "$WORKING_DIR/${dir_name}" --log-filepath "$WORKING_DIR/${dir_name}/pileup.log" --prefix "${dir_name}.cpg"
done
