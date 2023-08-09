#!/bin/bash

#Script for iterating through each subdirectory

script=/n/users/sgibson/quant_methylation/scripts/all_cpgs_chr.sh
Rscript=/n/users/sgibson/quant_methylation/scripts/region.R

module load R/4.2.3

INPUT_DIR=$1
OUTPUT_DIR=$2

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

Rscript $Rscript $INPUT_DIR $OUTPUT_DIR

echo "completed"