#!/usr/bin/perl

use strict;
use warnings;

# Define the directory you want to change to (make the directories first??)
my $directory = "/media/newdrive/GCB2024/aaronngai/automation/raw_fastq";  # alternative approach - my $home = <STDIN> , the user can then input the address of their home directory
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
        print "Running: $cmd\n";
    system($cmd) == 0 or warn "Failed to run $cmd: $!";
}

print "FastQC analysis complete.\n";
