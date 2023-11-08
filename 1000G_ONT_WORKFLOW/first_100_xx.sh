#!/bin/bash

#Copy the chrXperIsland files for XX samples to a new directory

list=/n/users/sgibson/reference/first_100_xx.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_MODKIT
OUTPUT_DIR=//n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_XX

readarray -t directory_list < "$list"

cd $INPUT_DIR

# Find directories matching the list of XX samples and copy over the chrXperIsland file
for subdirectory_path in "$INPUT_DIR"/*; do
    if [ -d "$subdirectory_path" ]; then
        subdirectory_name=$(basename "$subdirectory_path")

            # Check if the first 7 characters match any in the list
            if [[ " ${directory_list[@]} " =~ " $subdirectory_name " ]]; then
            scp "$subdirectory_path/chrXperIsland.tsv" "$OUTPUT_DIR/${subdirectory_name}_chrXperIsland.tsv"
        fi
    fi
done
