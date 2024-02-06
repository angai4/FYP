#!/usr/bin/perl

use strict;
use warnings;

# Define the directory you want to change to
my $directory = "/media/newdrive/GCB2024/aaronngai/automation/raw_fastq";
my $fastqc_output_dir = "/media/newdrive/GCB2024/aaronngai/automation/raw_fastq/FastQ\
C";

# Change to the specified directory
chdir $directory or die "Cannot change to directory $directory: $!";

print "Successfully changed to directory: $directory\n";

# Get a list of FASTQ files
my @fastq_files = glob("*.fastq.gz"); # maybe use grep

foreach my $file (@fastq_files) {
    # Run FastQC
    my $cmd = "fastqc --outdir=$fastqc_output_dir $file";

