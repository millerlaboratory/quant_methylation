#!/bin/bash

#Selects from a smaller list of samples for processing

INPUT_DIR=$1
WORKING_DIR=$2
REFERENCE=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta

module load modkit/0.1.11

cd $WORKING_DIR

mkdir modkit_processed

cd modkit_processed

directory_list=("M1312-NP-WGS-UDN-UDN550179")

# Loop through each directory in the current directory
for dir in $INPUT_DIR/*; do
    # Get the basename of the directory
    dirname=$(basename "$dir")

    # Check if the basename is in the list of directory names
    if [[ " ${directory_list[@]} " =~ " $dirname " ]]; then
        # Perform the desired function on the directory
        file=$(find $dir -type f -name "*phased.bam")
        modkit pileup "$file" --cpg --ref $REFERENCE -t 40 --ignore h --combine-strands --partition-tag HP "$WORKING_DIR/${dirname}" --log-filepath "$WORKING_DIR/${dirname}/pileup.log" --prefix "${dirname}.cpg"
        
    fi
done