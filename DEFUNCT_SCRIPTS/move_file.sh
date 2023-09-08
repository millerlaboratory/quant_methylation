#!/bin/bash

INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs

cd $INPUT_DIR

for subdirectory_path in "$INPUT_DIR"/*; do
    mv $subdirectory_path/*_DMR.tsv $OUTPUT_DIR/*_DMR.tsv
done