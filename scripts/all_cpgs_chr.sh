#!/bin/bash


#Run an r script for processeing unfiltered cpg files for analyzing individual cpg patterns, not cpg islands, right now, just label the file

WORKING_DIR=$1

cd $WORKING_DIR

for bed_file in $WORKING_DIR/*cpg_[1-2].bed; do
    # Perform bedtools intersect with the current BED file
    cat $bed_file | grep "chr16" | awk 'BEGIN {OFS="\t"} {print}'> "${bed_file%.bed}_all_chr16.bed"
done

for bed_file in $WORKING_DIR/*_chr16.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'-' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f2 ) #new naming scheme
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

cat *_labeled.bed > merged_chr16.bed

cat merged_chr16.bed | awk '{print $1 "\t" $2 "\t" $3 "\t" $10 "\t" $11 "\t" $19 "\t" $20}' | awk '$2 >=24539298'  | awk '$3 < 24575750' > chr16_translocation_region.bed 

rm *_all_chr16.bed
rm *_labeled.bed