#!/bin/bash

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs/SKEW

cd $INPUT_DIR

# List of input BED files
bed_files=($INPUT_DIR/*.tsv.bed)

# Perform the first intersection of the first two files
bedtools intersect -a "${bed_files[0]}" -b "${bed_files[1]}" > intersected_output.bed

# Iterate through the remaining BED files and perform the successive intersections
for ((i = 2; i < ${#bed_files[@]}; i++)); do
    bedtools intersect -a "intersected_output.bed" -b "${bed_files[$i]}" > tmp_output.bed
    mv tmp_output.bed intersected_output.bed
done