#!/bin/bash

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/test_set/
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/
rscript=/n/users/sgibson/quant_methylation/scripts/DMR_table.R

module load R/4.2.3

cd $INPUT_DIR

files=$(find "$INPUT_DIR" -type f -name "*_merged_haplotypes.bed")

cat $files > $OUTPUT_DIR/DMR_test.bed

cd $OUTPUT_DIR

Rscript $rscript $OUTPUT_DIR DMR_test.bed