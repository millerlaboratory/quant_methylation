#!/bin/bash

#Run DSS R sctipt for each group of samples 

module load python/3.9
module load R/4.2.3

source activate r_env

Rscript=/n/users/sgibson/quant_methylation/scripts/run_DSS.R
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs

cd $INPUT_DIR

# Loop through subdirectories
for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    cd "$subdir"
    Rscript "$Rscript" $subdir $OUTPUT_DIR
    
    echo "Script executed for directory: $subdir"
  fi
done