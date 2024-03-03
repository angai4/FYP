#!/usr/bin/perl 
use strict;
use warnings;
use File::Path 'make_path';

# This script will - Infer whether strand-specific RNA-seq data was performed, summarise mappping statistics of the BAM files, calculate read distribution, and calculate gene body coverage, then run multiqc on the results

# make directory for infer exp, bam stat, read dist, gene body coverage
my $inferexp_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/infer_experiment";
my $bamstat_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/bam_stat";
my $readdist_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/read_distribution";
my $genebody_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/genebodycoverage";

# The make_path function will create the directory and any necessary parent directories
make_path($inferexp_dir);
make_path($bamstat_dir);
make_path($readdist_dir);
make_path($genebody_dir);

# BAM file path
my $bam_path = "$ENV{HOME}/automation/coordinate_sorted_bams";

# Infer whether strand-specific RNA-seq data was performed

# Change to directory with the bam files

chdir $bam_path or die "Cannot change to directory $bam_path: $!";
print "Successfully changed to directory: $bam_path\n";

# Getting all the files matching the pattern *Aligned.sortedByCoord.out.bam
my @files = glob("*Aligned.sortedByCoord.out.bam");

foreach my $file (@files) {
    # Extracting the base name for the output file using substitution regular expression
    (my $base = $file) =~ s/Aligned\.sortedByCoord\.out\.bam//; # substitute the pattern found in between "/ / with nothing"

    # Constructing the inferexp command
    my $inferexp = "infer_experiment.py -r /media/newdrive/data/Reference_genomes/Human/UCSC/hg38.ncbiRefSeq.bed12 -i $file > $inferexp_dir/${base}.inferexp.txt";

    # Execute the command
    system($inferexp) == 0
        or die "Failed to execute infer_experiment: $!";

    # Construct the bam stat command
    my $bamstat = "bam_stat.py -i $file > $bamstat_dir/${base}.bamstats.txt"; # Summarizing mapping statistics of a BAM or SAM file: bam_stat.py

    # Execute the command
    system($bamstat) == 0 
        or die "Failed to execute bam_stat: $!";

    # Construct the read distribution command
    my $readdist = "read_distribution.py -i $file -r /media/newdrive/data/Reference_genomes/Human/UCSC/hg38.ncbiRefSeq.bed12 > $readdist_dir/${base}.read_dist.txt"; # Calculate how mapped reads were distributed over genome feature (like CDS exon, 5’UTR exon, 3’ UTR exon, Intron, Intergenic regions): read_distribution.py

    # Execute the command 
    system($readdist) == 0 
        or die "Failed to execute read_dist: $!";
    
}

# 
chdir $inferexp_dir or die "Cannot change to directory $inferexp_dir: $!";
print "Successfully changed to directory: $inferexp_dir\n"; 

# Run MultiQC
my $multiqc_inferexp = "multiqc $inferexp_dir -n rseqc_inferexperiment_multiqc";
system($multiqc_inferexp) == 0
    or die "Failed to execute MultiQC on $inferexp_dir: $!";

# 
chdir $readdist_dir or die "Cannot change to directory $readdist_dir: $!";
print "Successfully changed to directory: $readdist_dir\n"; 

# Run MultiQC
my $multiqc_readdist = "multiqc $readdist_dir -n rseqc_readdistribtuion_multiqc";
system($multiqc_readdist) == 0
    or die "Failed to execute MultiQC on $readdist_dir: $!";

#


    







