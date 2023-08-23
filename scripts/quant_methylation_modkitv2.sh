#!/bin/bash

#Uses modkit on patient samples either through the CARD pipeline or Miller Lab pipeline

INPUT_DIR=$1
WORKING_DIR=$2
REFERENCE=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta

module load modkit/0.1.11
module load  samtools/1.17

cd $WORKING_DIR

directory_list=("M1082-NP-WGS-SV-X-A-translocation-chla-daughter" "M1083-NP-WGS-SV-X-A-translocation-chla-mom")

# Loop through each directory in the current directory
for dir in $INPUT_DIR/*; do
    # Get the basename of the directory
    dirname=$(basename "$dir")

    # Check if the basename is in the list of directory names
    if [[ " ${directory_list[@]} " =~ " $dirname " ]]; then
        # Perform the desired function on the directory
        file=$(find $INPUT_DIR/$dirname -type f -name "*phased.bam")
        modkit pileup "$file" --cpg --ref $REFERENCE -t 40 --ignore h --combine-strands --partition-tag HP "$WORKING_DIR/${dirname}" --log-filepath "$WORKING_DIR/${dirname}/pileup.log" --prefix "${dirname}.cpg"
        
    fi
done

#bed_files=$(find -type f -name "*cpg_[1-2].bed")

#for bed_file in $bed_files; do
  #bgzip "$bed_file"
#done

echo "modkit complete"