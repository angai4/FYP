#!/usr/bin/perl
use strict;
use warnings;

# Define the directory you want to change to
my $directory = "/media/newdrive/GCB2024/aaronngai/automation/raw_fastq";

# Change to the specified directory
chdir $directory or die "Cannot change to directory $directory: $!";

print "Successfully changed to directory: $directory\n";

# Getting all the files matching the pattern *_1.fastq.gz
my @files = glob("*_1.fastq.gz");

foreach my $file (@files) {
    # Extracting the base name for the output file using substitution regular expression
    (my $base = $file) =~ s/_1\.fastq\.gz//; # substitute the pattern found in between with nothing"/ /" 
