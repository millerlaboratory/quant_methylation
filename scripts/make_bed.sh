#!/bin/bash

WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS_DMRs/SKEW

cd $WORKING_DIR

for file in $WORKING_DIR/*.tsv; do
cat $file | awk '{print $1 "\t" $2 "\t" $3}' | tail -n +2 > $WORKING_DIR/${file##*/}.bed
done
