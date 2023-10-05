#!/bin/bash

#Calculate DMR scores comparing haplotypes in XX samples

list=/n/users/sgibson/reference/1000g_XX.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/v0.1.11_processed
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX
REF=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta
BED=/n/users/sgibson/reference/chrX_cpgIslands.hg38_NUM_FOR_INTERSECT.bed

module load samtools/1.17
module load modkit/0.2.0

readarray -t directory_list < "$list"

cd $INPUT_DIR

# Find directories matching the list of XX samples and copy over the chrXperIsland file
for subdirectory_path in "$INPUT_DIR"/*; do
    if [ -d "$subdirectory_path" ]; then
        subdirectory_name=$(basename "$subdirectory_path")
        first_seven_chars=$(echo "${subdirectory_name:0:7}")  # Extract the first 7 characters

            # Check if the first 7 characters match any in the list
            if [[ " ${directory_list[@]} " =~ " $first_seven_chars " ]]; then
            HP1=$(find $subdirectory_path -type f -name "*cpg_1.bed.gz")
            HP2=$(find $subdirectory_path -type f -name "*cpg_2.bed.gz")
            #tabix $HP1
            #tabix $HP2
            HP1_i=$(find $subdirectory_path -type f -name "*cpg_1.bed.gz.tbi")
            HP2_i=$(find $subdirectory_path -type f -name "*cpg_2.bed.gz.tbi")

            modkit dmr pair \
                -a $HP1 \
                --index-a $HP1_i \
                -b $HP2 \
                --index-b $HP2_i \
                -o ${OUTPUT_DIR}/${subdirectory_name}_chrX_cpg_score.bed \
                -r $BED \
                --ref $REF \
                --base C \
                --threads 40 \
                --log-filepath dmr.log

            echo "$subdirectory_name complete"

        fi
    fi
done

#cd $OUTPUT_DIR

#for file in $OUTPUT_DIR/*.bed; do
    #sample=$(echo "${file##*/}" | cut -d'.' -f1) #Sample labeling compliant with 1000g samples
    #awk -v OFS="\t" -v sample="$sample" '{print $0 "\t" sample}' "$file" > "$file"
#done

echo "Script complete"


