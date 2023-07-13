#!/bin/bash

#Script for running the bedtools interect and quantification script on each 1000g sample

script=/n/users/sgibson/quant_methylation/scripts/modkit_intersect.sh

module load samtools/1.12  
module load bedtools/2.30.0
module load R/4.2.3

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/v0.1.11

cd $INPUT_DIR

# Loop through subdirectories
for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    cd "$subdir"
    sh "$script" $subdir
    
    echo "Script executed for directory: $subdir"
  fi
done
