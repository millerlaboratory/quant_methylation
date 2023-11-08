#!/bin/bash

#Calculate DMR scores comparing haplotypes at clinically relevant loci

INPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_MODKIT
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/FIRST_100_DMR
REF=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta
BED=/n/users/sgibson/reference/1000g_BW_Compare_sorted.bed

module load samtools/1.17
module load modkit/0.2.0

cd $INPUT_DIR

# Find directories matching the list of XX samples and copy over the chrXperIsland file
for subdirectory_path in "$INPUT_DIR"/*; do
    subdirectory_name=$(basename $subdirectory_path)
    HP1=$(find $subdirectory_path -type f -name "*cpg_1.bed.gz")
    HP2=$(find $subdirectory_path -type f -name "*cpg_2.bed.gz")
    tabix -f $HP1
    tabix -f $HP2
    HP1_i=$(find $subdirectory_path -type f -name "*cpg_1.bed.gz.tbi")
    HP2_i=$(find $subdirectory_path -type f -name "*cpg_2.bed.gz.tbi")
        modkit dmr pair \
            -a $HP1 \
            --index-a $HP1_i \
            -b $HP2 \
            --index-b $HP2_i \
            -o ${OUTPUT_DIR}/${subdirectory_name}_AR_score.bed \
            -r $BED \
            --ref $REF \
            --base C \
            --threads 20 \
            --log-filepath ${OUTPUT_DIR}/dmr.log
            echo "$subdirectory_name complete"
done

cd $OUTPUT_DIR

for file in $OUTPUT_DIR/*.bed; do
    sample=$(echo "${file##*/}" | cut -d'.' -f1) #Sample labeling compliant with 1000g samples
    awk -v OFS="\t" -v sample="$sample" '{print $0 "\t" sample}' "$file" > "${file%.bed}_name.bed"
    rm $file
done

cat *_name.bed > 1000g_DMR_score.bed

echo "Script complete"