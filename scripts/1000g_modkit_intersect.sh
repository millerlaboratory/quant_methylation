#!/bin/bash

WORKING_DIR=$1

RScript=/n/users/sgibson/github_repo/quant_methylation/scripts/calcMeth_modkit.R
Reference_bed=/n/users/sgibson/reference/cpgIslands.hg38_NUM_FOR_INTERSECT.bed
GENE_FILE=/n/users/sgibson/reference/cpgIslands.gene.tsv

cd $WORKING_DIR

module load bedtools/2.30.0
module load R/4.2.3

# Loop through each BED file in the directory
for bed_file in $WORKING_DIR/*cpg_[1-2].bed; do
    # Perform bedtools intersect with the current BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $22}' > "${bed_file%.bed}_Islands.bed"
done

#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*_Islands.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1) #Sample labeling compliant with 1000g samples
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f2) #Haplotype scheme compliant with 1000g naming structure, not Miller lab samples
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

#Merge all of the samples into one bed file
cat *_labeled.bed > merged_haplotypes.bed

rm *_labeled.bed
rm *_Islands.bed

#Separate by chromosome
awk '{print > $1".bed"}' merged_haplotypes.bed


Rscript $RScript $WORKING_DIR chrX $GENE_FILE

bed_files=$(find $INPUT_DIR -type f -name "*cpg_[1-2].bed")

for file in $bed_files; do
  bgzip "$file"
done

bgzip *_ungrouped.bed