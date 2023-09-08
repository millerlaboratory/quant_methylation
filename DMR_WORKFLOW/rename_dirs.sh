#!/bin/bash

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/v0.1.11_processed

cd $INPUT_DIR

for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    subdirectory_name=$(basename "$subdir")
    new_name=$(echo "${subdirectory_name:0:17}")
    
    mv "$subdir" "$INPUT_DIR/$new_name"

  fi
done