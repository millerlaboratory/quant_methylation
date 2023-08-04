#!/bin/bash

WORKING_DIR=$1

RScript=/n/users/sgibson/quant_methylation/scripts/calcMeth_modkit.R
Reference_bed=/n/users/sgibson/reference/cpg_ann.bed

GENE_FILE=/n/users/sgibson/reference/cpgIslands.gene.tsv

cd $WORKING_DIR

module load bedtools/2.30.0
module load samtools/1.12

# Annotate each file with cpg information
for bed_file in $WORKING_DIR/*cpg_[1-2].bed.gz; do
    # Perform bedtools intersect with the current BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    |awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $24 "\t" $25}'> "${bed_file%.bed}_cpg_regions.bed"
done

#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*_cpg_regions.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f4 | cut -d '.' -f1) #new naming scheme
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

#Merge all of the samples into one bed file
cat *_labeled.bed > annotated_merged_haplotypes.bed

rm *_cpg_regions.bed
rm *_labeled.bed

mkdir new_annotation

mv annotated_merged_haplotypes.bed new_annotation/annotated_merged_haplotypes.bed

cd new_annotation

awk '{print > $1".bed"}' annotated_merged_haplotypes.bed

bgzip annotated_merged_haplotypes.bed