#!/bin/bash

#Script for running the bedtools interect and quantification script on each 1000g sample

script=/n/users/sgibson/github_repo/quant_methylation/scripts/1000g_modkit_intersect.sh
sample_processed=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/samples_already_processed.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/

module load samtools/1.12  
module load bedtools/2.30.0
module load R/4.2.3

cd $INPUT_DIR

readarray -t sample_done < "$sample_processed"

# Match the basename for each modkit processed directory with the list of ones that had already been processed
for subdir in "$INPUT_DIR"/*; do
    if [ -d "$subdir" ]; then
        dirname=$(basename "$subdir")

          # Only run intersect script on directories not previously processed
            if [[ ! " ${sample_done[@]} " =~ " $dirname " ]]; then
            cd "$subdir"
            sh "$script" $subdir
            echo "Script executed for directory: $subdir"
            
        fi
    fi
done
