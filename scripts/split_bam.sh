#!/bin/bash


#modkit has a tag for haplotypes, so this is no longer needed.

INPUT_DIR=/n/1000g/align-card-2.24-hg38
WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit
directory_list_file="/n/users/sgibson/1000g_methylation/directory_list.txt"

module load samtools/1.12  

while IFS= read -r directory_name; do
    # Create the matching output directory
    mkdir -p "$WORKING_DIR/$directory_name"
    
    # Copy the file from the input directory to the output directory
    for file in $INPUT_DIR/$directory_name/*.haplotagged.bam; do
    samtools view -b -d HP:1 --threads 10 "$file" chrX > "$WORKING_DIR/$directory_name/${file##*/}.chrX.hp1.bam"
    samtools view -b -d HP:2 --threads 10 "$file" chrX > "$WORKING_DIR/$directory_name/${file##*/}.chrX.hp2.bam"
    done
done < "$directory_list_file"

bamfiles=$(find "$WORKING_DIR" -type f -name "*.bam")

for file in $bamfiles; do
	samtools index "$file"
done
