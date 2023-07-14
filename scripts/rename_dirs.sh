#!/bin/bash

WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/v0.1.11/

cd $WORKING_DIR

for subdir in "$WORKING_DIR"/*; do
  if [ -d "$subdir" ]; then
    # Run the shell script for each subdirectory
    subdirectory_name=$(basename "$subdir")
    new_name=$(echo "${subdirectory_name:0:17}")
    
    mv "$WORKING_DIR/$subdir" "$WORKING_DIR/$new_name"

  fi
done