#!/bin/bash

WORKING_DIR=$1

cd $WORKING_DIR

for bed_file in $WORKING_DIR/*cpg_1.bed.gz; do
    file=$(basename $bed_file)
    char=${file:0:17}

    mv $bed_file $WORKING_DIR/${char}.cpg_1.bed.gz
done


for bed_file in $WORKING_DIR/*cpg_2.bed.gz; do
    file=$(basename $bed_file)
    char=${file:0:17}
   echo $char
done