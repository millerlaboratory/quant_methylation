#!/bin/bash

list=/n/users/sgibson/reference/1000g_XX.txt
INPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/v0.1.11_processed
OUTPUT_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit/modkit_v0.1.11/DSS

#readarray -t directory_list < "$list"
module load samtools/1.12 

cd $INPUT_DIR

#Unzip cpg files
#zipped_bed_files=$(find $INPUT_DIR -type f -name "*cpg_[1-2].bed.gz")

#for file in $zipped_bed_files; do
  #gunzip "$file"
#done

# Find directories matching the list of XX samples and copy over the chrXperIsland file
#for subdirectory_path in "$INPUT_DIR"/*; do
    #if [ -d "$subdirectory_path" ]; then
        #subdirectory_name=$(basename "$subdirectory_path")
        #first_seven_chars=$(echo "${subdirectory_name:0:7}")  # Extract the first 7 characters

            # Check if the first 7 characters match any in the list
            #if [[ " ${directory_list[@]} " =~ " $first_seven_chars " ]]; then
            #cd $subdirectory_path
            #mkdir $OUTPUT_DIR/$first_seven_chars
               # for bed_file in $subdirectory_path/*cpg_[1-2].bed; do
                    # Extract X chromosome CpG counts
                    #cat $bed_file | grep "chrX" | awk '{print $1 "\t" $2 "\t" $10 "\t" $12}' > "$OUTPUT_DIR/$first_seven_chars/${bed_file##*/}_chrX.bed"
                    #done
            
            
       # fi
    #fi
#done

#Once all of the files have been generated, compress the cpg bed files
bed_files=$(find $INPUT_DIR -type f -name "*cpg_[1-2].bed")

ungrouped=$(find $INPUT_DIR -type f -name "*_ungrouped.bed")

for file in $bed_files; do
  bgzip "$file"
done

for file in $ungrouped; do
    bgzip "$file"
done
