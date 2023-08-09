#!/bin/bash

#Copy the chrXperIsland files for XX samples to a new directory and run an Rscript to generate the outputs for an R shiny app

list=/n/users/sgibson/reference/1000g_XX.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/XX_X_cpg


module load R/4.2.3

readarray -t directory_list < "$list"

cd $INPUT_DIR

# Find directories matching the list of XX samples and copy over the chrXperIsland file
for subdirectory_path in "$INPUT_DIR"/*; do
    if [ -d "$subdirectory_path" ]; then
        subdirectory_name=$(basename "$subdirectory_path")
        first_seven_chars=$(echo "${subdirectory_name:0:7}")  # Extract the first 7 characters

            # Check if the first 7 characters match any in the list
            if [[ " ${directory_list[@]} " =~ " $first_seven_chars " ]]; then
            cat "$subdirectory_path/merged_chrX.bed" | awk '{print $1 "\t" $2 "\t" $3 "\t" $10 "\t" $11 "\t" "\t" $19 "\t" $20}' > "$OUTPUT_DIR/${subdirectory_name}_merged_chrX.bed"
        fi
    fi
done

