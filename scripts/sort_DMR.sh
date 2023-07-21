#!/bin/bash

# Directory path containing the files
WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs

# Destination directory to move files with more lines
SKEW=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs/SKEW
RANDOM=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs/RANDOM

cd $WORKING_DIR

# Define the threshold for the number of lines
line_threshold=100  # Change this to the desired number of lines

# Loop through the files in the source directory
for file in "$WORKING_DIR"/*; do
    # Count the number of lines in the file
    line_count=$(wc -l < "$file")

    # Compare line count with the threshold and move the file if it exceeds
    if [ "$line_count" -lt "$line_threshold" ]; then
        scp "$file" "$RANDOM"
    fi
done
