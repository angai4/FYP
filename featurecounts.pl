#!/usr/bin/perl
use strict;
use warnings;
use File::Path 'make_path';

# Create relevant directories 
my $name_sorted_bams_dir = "$ENV{HOME}/automation/name_sorted_bams";
my $counts_dir = "$ENV{HOME}/automation/counts";

make_path($name_sorted_bams_dir)
make_path($counts_dir)
print "Successfully created the following directories: $name_sorted_bams_dir and $counts_dir\n";

# Define the directory with the BAM files 
my $bam_dir = "$ENV{HOME}/automation/coordinate_sorted_bams";

# Change to directories with the BAM files
chdir $bam_dir or die "Cannot change to directory $bam_dir: $!";

# Create name-sorted bam file

# Getting all the files matching the pattern *Aligned.sortedByCoord.out.bam
my @files = glob("*Aligned.sortedByCoord.out.bam");

foreach my $file (@files) {
 # Extracting the base name for the output file using substitution regular expression
  (my $base = $file) =~ s/Aligned\.sortedByCoord\.out\.bam//; # substitute the pattern found in between / / with nothing

  # Constructing the samtools command 
  my $samtools = "samtools sort -n -@ 12 -o $name_sorted_bams_dir/${base}_namesorted.bam $file";

  # Execute the command 
  system($samtools) == 0 
    or die "Failed to execute $samtools: $!";



