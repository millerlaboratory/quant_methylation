#!/bin/bash

WORKING_DIR=$1
INPUT_DIR=$2

REFERENCE=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta
RScript=/n/users/sgibson/scripts/calcMeth_modkit.R
Reference_bed=/n/users/sgibson/reference/cpgIslands.hg38_NUM_FOR_INTERSECT.bed

GENE_FILE=/n/users/sgibson/reference/cpgIslands.gene.tsv

module load samtools/1.12  
module load bedtools/2.30.0
module load modkit/0.1.3


cd $WORKING_DIR

for file in $INPUT_DIR/*.bam; do
samtools view -b -d HP:1 --threads 10 "$file" >"$WORKING_DIR/$NUM.hp1.bam"
done

for file in $INPUT_DIR/*.bam; do
samtools view -b -d HP:2 --threads 10 "$file" >"$WORKING_DIR/$NUM.hp2.bam"
done


samtools index *.hp1.bam

samtools index *.hp2.bam

for file in $WORKING_DIR/*.hp1.bam; do
modkit pileup "$file" --cpg --ref $REFERENCE "${file}.cpg.bed"
done

for file in $WORKING_DIR/*.hp2.bam; do
modkit pileup "$file" --cpg --ref $REFERENCE "${file}.cpg.bed"
done


# Loop through each BED file in the directory
for bed_file in $WORKING_DIR/*.cpg.bed; do
    # Perform bedtools intersect with the current BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $22}' > "${bed_file%.bed}_Islands.bed"
done



#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*.cpg_Islands.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'.' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'.' -f2)
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

#Merge all of the samples into one bed file
cat *_labeled.bed > merged_haplotypes.bed

#Separate by chromosome
awk '{print > $1".bed"}' merged_haplotypes.bed


Rscript $RScript $WORKING_DIR chrX $GENE_FILE



#Re-zip files
for bed_file in $WORKING_DIR/*.cpg.bed ; do
    bgzip "$bed_file"
done