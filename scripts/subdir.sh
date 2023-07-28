#!/bin/bash

#Script for running the bedtools interect and quantification script on each 1000g sample

script=/n/users/sgibson/quant_methylation/scripts/DMR_intersect.sh

module load samtools/1.12  
module load bedtools/2.30.0
module load R/4.2.3

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed

cd $INPUT_DIR

#Unzip cpg files
zipped_bed_files=$(find $INPUT_DIR -type f -name "*cpg_[1-2].bed.gz")

for file in $zipped_bed_files; do
  gunzip "$file"
done


# Loop through subdirectories
for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    cd "$subdir"
    sh "$script" $subdir
    
    echo "Script executed for directory: $subdir"
  fi
done

#Once all of the files have been generated, compress the cpg bed files
bed_files=$(find $INPUT_DIR -type f -name "*cpg_[1-2].bed")

for file in $bed_files; do
  bgzip "$file"
done
