#!/bin/bash

#Copy the chrXperIsland files for XX samples to a new directory and run an Rscript to generate the outputs for an R shiny app

list=/n/users/sgibson/reference/1000g_XX.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/
OUTPUT_DIR=//n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed/XX_chrX
Rscript=/n/users/sgibson/quant_methylation/scripts/shiny_tables.R

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
            scp "$subdirectory_path/chrXperIsland.tsv" "$OUTPUT_DIR/${subdirectory_name}_chrXperIsland.tsv"
        fi
    fi
done


#Run R script

Rscript $Rscript $OUTPUT_DIR