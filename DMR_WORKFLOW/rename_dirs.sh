#!/bin/bash

#Rename directories in name scheme shift

INPUT_DIR=$1

cd $INPUT_DIR

for subdir in "$INPUT_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    subdirectory_name=$(basename "$subdir")
    new_name=$(echo "${subdirectory_name:0:17}")
    
    mv "$subdir" "$INPUT_DIR/$new_name"

  fi
done