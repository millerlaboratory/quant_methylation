#!/bin/bash

list=/n/users/sgibson/reference/1000g_XX.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/v0.1.11
OUTPUT_DIR=/n/users/sgibson/v0.1.11/XX_chrX

readarray -t directory_list < "$list"

cd $INPUT_DIR

# Iterate through the files in the source directory
for subdirectory_path in "$INPUT_DIR"/*; do
    if [ -d "$subdirectory_path" ]; then
        subdirectory_name=$(basename "$subdirectory_path")
        first_seven_chars=$(echo "${subdirectory_name:0:7}")  # Extract the first 7 characters

            # Check if the first 7 characters match any in the list
            if [[ " ${directory_list[@]} " =~ " $first_seven_chars " ]]; then
            scp "$subdirectory_path/chrXperIsland.tsv" "$OUTPUT_DIR/${first_seven_chars}_chrXperIsland.tsv"
        fi
    fi
done
