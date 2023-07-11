#!/bin/bash

INPUT_DIR=/n/1000g/align-card
WORKING_DIR=/n/users/sgibson/1000g_methylation/1000g_modkit
REF=/n/users/sgibson/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions_v2.fasta


module load quast

cd $WORKING_DIR

# Find all fasta files within subdirectories
fasta_files=$(find "$INPUT_DIR" -type f -name "*.haplotagged.bam")

# Iterate over each fasta file
for file in $fasta_files; do
samtools view -b -d HP:1 --threads 10 "$file" >"$WORKING_DIR/$NUM.hp1.bam"
samtools view -b -d HP:2 --threads 10 "$file" >"$WORKING_DIR/$NUM.hp2.bam"
done