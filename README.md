# Quantifying methylation data from ONT Long Reads
This repository is a collection of scripts that are being developed into a pipeline for processing methylation data from aligned ONT long reads. The current output is used for visualzing methylation data from samples sequenced as part of the 1000 Genomes ONT Sequencing consortium (https://millerlaboratory.com/1000G-ONT.html) for the ONT Data Explorer R shiny app: https://millerlaboratory.shinyapps.io/Data_Explorer_V1/. The goal is to use the eventual pipeline for determining X-inactivation status for individuals with two X chromosomes. These scripts are written and maintianed by Sophia Gibson in the Miller Laboratory at The University of Washington.

![image](https://github.com/millerlaboratory/quant_methylation/assets/73716087/36f1ad19-2bc3-4f44-8c87-001cdac3c9f7)


The main pipleline components are in **1000G_ONT_WORKFLOW**. This workflow applies modkit developed by Oxford Nanopore (https://github.com/nanoporetech/modkit) to generate haplotype-resolved bedMethyl pileups for all CpG sites in the genome. From there, the bedMethyl files can be intersected with region-specifc BED files to visualize methylation patterns in R. The default usages is to filter for CpGs found within known CpG islands (source UCSC Genome Browser) to look at regions of skewed methylation on the X chromosome.
