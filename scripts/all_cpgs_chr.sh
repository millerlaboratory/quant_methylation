#!/bin/bash


#Run an r script for processeing unfiltered cpg files for analyzing individual cpg patterns, not cpg islands, right now, just label the file

WORKING_DIR=$1

for bed_file in $WORKING_DIR/*cpg_[1-2].bed.gz; do
    # Perform bedtools intersect with the current BED file
    zcat $bed_file | grep "chrX" | awk 'BEGIN {OFS="\t"} {print}'> "${bed_file%.bed}_chrX.bed"
done

for bed_file in $WORKING_DIR/*_chrX.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f4 | cut -d '.' -f1) #new naming scheme
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

cat *_labeled.bed > merged_chrX.bed


rm *.gz_chrX.bed
rm *_labeled.bed