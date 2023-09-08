#!/bin/bash

#Script for running the bedtools interect and quantification script on each 1000g sample

script=/n/users/sgibson/github_repo/quant_methylation/1000G_ONT_WORKFLOW/1000g_modkit_intersect.sh
RScript=/n/users/sgibson/github_repo/quant_methylation/1000G_ONT_WORKFLOW/calcMeth_modkit.R
sample_processed=$1
WORKING_DIR=$2
Reference_bed=$3 #BED file for all CpG islands in hg38

cd $INPUT_DIR

readarray -t sample_done < "$sample_processed"

# Match the basename for each modkit processed directory with the list of ones that had already been processed
for subdir in "$INPUT_DIR"/*; do
    if [ -d "$subdir" ]; then
        dirname=$(basename "$subdir")

          # Only run intersect script on directories not previously processed
            if [[ ! " ${sample_done[@]} " =~ " $dirname " ]]; then
            cd "$subdir"
            sh "$script" $subdir $Rscript $Reference_bed
            echo "Script executed for directory: $subdir"
            
        fi
    fi
done
