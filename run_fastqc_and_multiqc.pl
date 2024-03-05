#!/usr/bin/perl

use strict;
use warnings;
use File::Path 'make_path';

# Define the directory you want to change to (make the directories first??)
my $fastq_dir = "$ENV{HOME}/automation/raw_fastq";  
my $fastqc_output_dir = "$ENV{HOME}/automation/raw_fastq/FastQC";

makepath($fastqc_output_dir);

# Change to the specified directory
chdir $fastq_dir or die "Cannot change to directory $fastq_dir: $!";

print "Successfully changed to directory: $fastq_dir\n";

# Get a list of FASTQ files
my @fastq_files = glob("*.fastq.gz"); # maybe use grep

foreach my $file (@fastq_files) {
    # Run FastQC
    my $cmd = "fastqc --outdir=$fastqc_output_dir $file";
        print "Running: $cmd\n";
    system($cmd) == 0 or warn "Failed to run $cmd: $!";
}

print "FastQC analysis complete.\n";

# Run MultiQC on the FastQC output

my $multiqc_cmd = "multiqc -o $fastqc_output_dir $fastqc_output_dir";
system($multiqc_cmd) == 0 or die "Failed to run MultiQC: $!";

print "MultiQC report generated.\n";
