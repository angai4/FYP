#!/usr/bin/perl 
use strict;
use warnings;
use File::Path 'make_path';

# This script will - Infer whether strand-specific RNA-seq data was performed, summarise mappping statistics of the BAM files, calculate read distribution, and calculate gene body coverage, then run multiqc on the results

# make directory for infer exp, bam stat, read dist, gene body coverage
my $inferexp = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/infer_experiment";
my $bamstat = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/bam_stat";
my $readdist = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/read_distribution";
my $genebody = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/genebodycoverage";

# The make_path function will create the directory and any necessary parent directories
make_path($inferexp);
make_path($bamstat);
make_path($readdist);
make_path($genebody);


