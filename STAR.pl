#!/usr/bin/perl

use strict;
use warnings;

# This script will align all fastq files within a directory using STAR, output them to a new directory defined by the user, and run MultiQC on the related files

# Check for the correct number of arguments
if (@ARGV < 4) {
    die "Usage: $0 <path_to_STAR_dir> <path_to_refgenome_dir> <path_to_fastq_dir> <path_to_output_dir>\n";
}

# Assign command-line arguments to variables
my ($star_path, $refgenome_path, $fastq_path, $output_path) = @ARGV;

# Verify if STAR path exists and is executable
unless (-x $star_path) {
    die "Error: STAR executable path '$star_path' is not valid or not executable.\n";
}

# Verify if genome directory exists
unless (-d $refgenome_path) {
    die "Error: Reference Genome directory '$refgenome_path' does not exist.\n";
}

# Verify if FASTQ directory exists
unless (-d $fastq_path) {
    die "Error: FASTQ directory '$fastq_path' does not exist.\n";
}

# Verify if output directory exists, if not try to create it
unless (-d $output_path) {
    print "Output directory '$output_path' does not exist, attempting to create it...\n";
    mkdir $output_path or die "Error: Failed to create output directory '$output_path'.\n";
}

# Change to directory with the fastq files

chdir $fastq_path or die "Cannot change to directory $fastq_path: $!";

print "Successfully changed to directory: $fastq_path\n";
# Get a list of FASTQ files matching the pattern *_1.fastq.gz
my @fastq_files = glob("*_1.fastq.gz");

foreach my $file (@fastq_files) {
    # Extracting the base name using substitution regular expression
    (my $base = $file) =~ s/_1\.fastq\.gz//; # substitute the pattern found in between / / with nothing

    # Constructing the STAR command - note: $refgenome_path/x (x = your reference genome file), and sjdbOverhang y (y = maximum read length - 1)

    my $STAR = "STAR --genomeDir $star_path --runThreadN 12 --readFilesIn ${base}_1.fastq.gz ${base}_2.fastq.gz --readFilesCommand zcat --outFileNamePrefix $output_path/${base} --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard --sjdbGTFfile $refgenome_path/hg38.ncbiRefSeq.gtf --sjdbOverhang 49";

    # Execute the command
    system($STAR) == 0
        or die "Failed to execute STAR: $!";
}

# Change to directory with the bams and related files

chdir $output_path or die "Cannot change to directory $output_path: $!";
print "Successfully changed to directory: $output_path\n";

# Run MultiQC

my $multiqc_cmd = "multiqc $output_path -n STAR_multiqc";
system($multiqc_cmd) == 0 or die "Failed to run MultiQC: $!";

