#!/bin/bash

#Move samples from the first 100 to a new file to make analysis consistent

#INPUT_DIR=/n/1000g/align-card-2.24-hg38/FIRST_100
WORKING_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/v0.1.11_processed
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_MODKIT

cd $OUTPUT_DIR

output_file=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_MODKIT/FIRST_100.txt

# Loop through subdirectories and write them to the output file
#for dir in "$INPUT_DIR"/*/; do
    #basename "${dir%/}" >> "$output_file"
#done

readarray -t subdirs < "$output_file"

for dir in $WORKING_DIR/*; do
    # Get the basename of the directory
    dirname=$(basename "${dir%/}")

    # Check if the basename is in the list of output directory names, copy over phased modkit output files
    if [[ " ${subdirs[@]} " =~ " $dirname " ]]; then
        mkdir $OUTPUT_DIR/$dirname
        file1=$(find $dir -type f -name "*.cpg_1.bed.gz")
        file2=$(find $dir -type f -name "*.cpg_2.bed.gz")
        scp $file1 "$OUTPUT_DIR/$dirname/${dirname}.cpg_1.bed.gz"
        scp $file1 "$OUTPUT_DIR/$dirname/${dirname}.cpg_2.bed.gz"
    fi
done
