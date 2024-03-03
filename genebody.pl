#!/usr/bin/perl
use strict;
use warnings;

my $genebody_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/genebodycoverage";
my $bam_path = "$ENV{HOME}/automation/coordinate_sorted_bams";

chdir $bam_path or die "Cannot change to directory $bam_path: $!";
print "Successfully changed to directory: $bam_path\n";

# Getting all the files matching the pattern *Aligned.sortedByCoord.out.bam
my @files = glob("*Aligned.sortedByCoord.out.bam");

foreach my $file (@files) {
    # Extracting the base name for the output file using substitution regular expression
    (my $base = $file) =~ s/Aligned\.sortedByCoord\.out\.bam//; # substitute the pattern found in between "/ / with nothing"

    # Run count number of alignments command 
    system("samtools view -c $file");
}
