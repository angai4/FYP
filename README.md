# BRAS: Bulk RNA-seq Automation Scripts

## Overview
This repository, BRAS (Bulk RNA-seq Automation Scripts), offers a suite of scripts designed to streamline the bulk RNA sequencing (RNA-seq) pipeline. RNA-seq is a vital tool in transcriptomics, used to analyze the quantity and sequences of RNA in a sample at any given moment. This analysis is crucial for understanding gene expression and regulation. Our scripts are crafted to simplify the RNA-seq process, enhancing accessibility and efficiency for researchers and bioinformaticians.

## Features
- **Automation**: Simplifies the entire RNA-seq pipeline from setup to analysis.
- **Flexibility**: Includes optional steps like trimming via `cutadapt.pl` based on specific research needs.
- **Comprehensive**: From creating directories to feature counts, manage all aspects of RNA-seq analysis.

## Prerequisites
Ensure you have a Linux environment with permissions to install and execute scripts. You will need tools like `emacs`, `chmod`, and necessary dependencies for running Perl scripts.

## Installation
Execute the scripts in the following order:
- **`create_initial_directories.pl`**
- **`cutadapt.pl`** (optional, skip if trimming is not required)
- **`STAR.pl`**
- **`indexbam.pl`**
- **`RSEQC.pl`**
- **`featurecounts.pl`**

## Usage

To ensure optimal functionality and results from the BRAS scripts, it is crucial to execute the scripts in the specific order outlined in the Installation section. Below are step-by-step instructions and examples to guide you through using each script effectively.

### Running the Scripts
After installation and setup, you can start using the scripts as follows:

1. **Create Initial Directories**:
   This script sets up the necessary directory structure required for the subsequent scripts to function correctly.
   ```bash
   ./create_initial_directories.pl

2. **Trimming with Cutadapt** (Optional):
   If your RNA samples require trimming to remove adapters or low-quality bases, run the `cutadapt.pl` script next. Skip this step if trimming is not necessary.
   ```bash
   ./cutadapt.pl

3. **Aligning Sequences with STAR**:
   This script processes the RNA sequences using the STAR aligner to map reads to the reference genome. Ensure that the reference genome and sjdbOverhang (maximum read length - 1) are correctly configured in your script settings before running. Note - <path_to_STAR_dir> = ~/automation/coordinate_sorted_bams and <path_to_output_dir> = ~/automation/coordinate_sorted_bams . 
   ```bash
   ./STAR.pl <path_to_STAR_dir> <path_to_refgenome_dir> <path_to_fastq_dir> <path_to_output_dir>

4. **Indexing BAM Files**:
   Post-alignment, this script indexes the generated BAM files to facilitate quicker data access in downstream analyses. Note <path_to_bam_dir> = ~/automation/coordinate_sorted_bams . 
   ```bash
   ./indexbam.pl <path_to_bam_dir>

5. **Quality Control with RSEQC**:
   To assess the quality of the RNA-seq data and ensure the integrity of the sequencing process. Ensure that the reference genome is correctly configured in your script settings before running.
   ```bash
   ./RSEQC.pl

6. **Counting Reads Asscoiated with Genes with FeatureCounts**:
   The final script in the pipeline counts the gene features from the aligned reads. Ensure that the reference genome is correctly configured in your script settings before running. By default this assumes a reverse-stranded library, if this is not the case adjust the parameters in the script settings. 
   ```bash
   ./featurecounts.pl

For additional guidance on script parameters or troubleshooting, please consult the script documentation or contact the author.

## Author
Aaron Ngai - aaronngai727@gmail.com

