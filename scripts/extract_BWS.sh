#!/bin/bash

WORKING_DIR=$1
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/chr11_BWS/for_shiny

Reference_bed=/n/users/sgibson/reference/BWS_DMR.bed

cd $WORKING_DIR

module load bedtools/2.30.0
module load R/4.2.3

#Re-name all cpg bed files to be the same scheme to make output file easier. Maintain the same scheme in updated scripts
for bed_file in $WORKING_DIR/*cpg_1.bed.gz; do
    file=$(basename $bed_file)
    char=${file:0:17}

    mv $bed_file $WORKING_DIR/${char}.cpg_1.bed.gz
done

for bed_file in $WORKING_DIR/*cpg_2.bed.gz; do
    file=$(basename $bed_file)
    char=${file:0:17}

    mv $bed_file $WORKING_DIR/${char}.cpg_2.bed.gz
done

# Loop through each BED file in the directory
for bed_file in $WORKING_DIR/*cpg_[1-2].bed.gz; do
    # Perform bedtools intersect with the current BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $22 "\t" $23}' > "${bed_file%.bed.gz}_BWS.bed"
done

#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*_BWS.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1) #Sample labeling compliant with 1000g samples
    hap=$(echo "${bed_file##*/}" | cut -d'_' -f2) #Haplotype scheme compliant with 1000g naming structure, not Miller lab samples
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

sample_name=$(echo $WORKING_DIR | cut -d'/' -f9 | cut -d'.' -f1)

#Merge all of the samples into one bed file
cat *_labeled.bed > $OUTPUT_DIR/${sample_name}_BWS_cpgs.bed

rm *_labeled.bed
rm *_BWS.bed