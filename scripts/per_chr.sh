#!/bin/bash

#Script for running the bedtools interect and quantification script on each 1000g sample

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/chr11_BWS/
Rscript=/n/users/sgibson/quant_methylation/scripts/calcMeth_per_chr.R
GENE_FILE=/n/users/sgibson/reference/cpgIslands.gene.tsv
CHR=$1

module load R/4.2.3

cd $INPUT_DIR

# Output chr15 for each sample
for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
     Run the shell script for each subdirectory
    cd "$subdir"
    sample=$(basename "$subdir")
    Rscript "$Rscript" $subdir $CHR $GENE_FILE $sample $OUTPUT_DIR
    
    echo "Script executed for directory: $subdir"
  fi
done

#merge
cd $OUTPUT_DIR

files=$(find "$OUTPUT_DIR" -type f -name "*chr11perIsland.tsv")

cat $files > merged_chr11.bed
