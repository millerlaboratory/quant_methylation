#!/bin/bash

WORKING_DIR=$1

Reference_bed=/n/users/sgibson/reference/akbari_DMR_FOR_INTERSECT.bed

module load samtools/1.12  
module load bedtools/2.30.0

for bed_file in $WORKING_DIR/*cpg_[1-2].bed; do
    # Perform bedtools intersect with the current BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $23}' > "${bed_file%.bed}_DMR.bed"
done

#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*_DMR.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f4) #new naming scheme
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_DMR_labeled.bed"
done

#Merge all of the samples into one bed file
cat *_labeled.bed > DMR_haplotypes.bed

rm *_labeled.bed
rm *_DMR.bed