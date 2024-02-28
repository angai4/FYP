#!/usr/bin/perl
use strict;
use warnings;

# This script will change to the directory that contains the bams and index the bam files

# Check for the correct number of arguments
if (@ARGV < 1) {
    die "Usage: $0 <path_to_bam_dir>\n";
}

# Assign command-line arguments to variables
my ($bam_path) = @ARGV;

# Verify if bam path exists and is executable
unless (-x $bam_path) {
    die "Error: BAM executable path '$bam_path' is not valid or not executable.\n";
}

# Change to directory with the bam files

chdir $bam_path or die "Cannot change to directory $bam_path: $!";
print "Successfully changed to directory: $bam_path\n";

# Getting all the files matching the pattern *Aligned.sortedByCoord.out.bam
my @bamfiles = glob("*Aligned.sortedByCoord.out.bam");

foreach my $file (@bamfiles) {
    # Execute samtools index command for each file
    system("samtools index $file -@ 12");
}

print "Successfully indexed bam files, they can be found in $bam_path\n";


