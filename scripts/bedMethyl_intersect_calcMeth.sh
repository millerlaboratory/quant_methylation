#!/bin/bash

INPUT_DIR=$1
WORKING_DIR=/n/users/sgibson/$2
CHR=$3

Reference_bed=/n/users/sgibson/reference/cpgIslands.hg38_NUM_FOR_INTERSECT.bed
RScript=/n/users/sgibson/scripts/calcMeth.R
GENE_FILE=/n/users/sgibson/reference/cpgIslands.gene.tsv

module load samtools/1.12  
module load bedtools/2.30.0
module load R/4.2.3

#Copy over bedMethyl files
for file in $INPUT_DIR/*.cpg.bed.gz; do
scp "$file" $WORKING_DIR
done

#Unzip bed files
cd $WORKING_DIR

gunzip *.cpg.bed.gz

#Loop through each BED file in the directory
for bed_file in $WORKING_DIR/*.cpg.bed; do
    #Perform bedtools intersect with the reference BED file
    bedtools intersect -wa -wb -a "$bed_file" -b $Reference_bed \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $18}' > "${bed_file%.bed}_Islands.bed"
done

#Add the sample name and haplotype as columns in each file
for bed_file in $WORKING_DIR/*.cpg_Islands.bed; do
    sample=$(echo "${bed_file##*/}" | cut -d'-' -f1)
    hap=$(echo "${bed_file##*/}" | cut -d'.' -f4) #This needs to be changed depending on the file name
    awk -v OFS="\t" -v sample="$sample" -v hap="$hap" '{print $0 "\t" sample "\t" hap}' "$bed_file" > "${bed_file%.bed}_labeled.bed"
done

#Merge all of the haplotype files and samples into one bed file
cat *_labeled.bed > merged_haplotypes.bed

#Split the merged file to chromosomes
awk '{print > $1".bed"}' merged_haplotypes.bed

#Run an R-script to make a % methylated per CpG island output that can be used to make figures. Default will be the X chromosome for now.

Rscript $RScript $WORKING_DIR $CHR $GENE_FILE



#for bed_file in *.cpg.bed ; do
    #bgzip "$bed_file"
#done