#!/bin/bash

#Run modkit on a sample and out put the DMR files for the X chromsomes

sh /n/users/sgibson/quant_methylation/scripts/quant_methylation_modkit.sh /n/alignments-card/M0744-NP-WGS-skewX-DMD-female-sib-SJ/ /n/users/sgibson/modkit_pipeline_output/ &

wait

mkdir /n/users/sgibson/modkit_pipeline_output/M0744/chrX_cpg

sh /n/users/sgibson/quant_methylation/scripts/extract_chrX_CpG.sh /n/users/sgibson/modkit_pipeline_output/M0744 /n/users/sgibson/modkit_pipeline_output/M0744/chrX_cpg &

wait


module load R/4.2.3

source activate r_env

Rscript /n/users/sgibson/quant_methylation/scripts/run_DSS.R /n/users/sgibson/modkit_pipeline_output/M0744/chrX_cpg

