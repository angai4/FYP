#!/usr/bin/perl
use strict;
use warnings;

# This script will change to the directory that contains the bams and index the bam files

# -@ specify number of threads to use
for i in *Aligned.sortedByCoord.out.bam; do
samtools index $i -@ 12
done

# Specify the directory that contains bam files
my bam_path = 

# Change to directory with the bam files

chdir $bam_path or die "Cannot change to directory $bam_path: $!";
print "Successfully changed to directory: $bam_path\n";

# Getting all the files matching the pattern *
my @bamfiles = glob("*");

foreach my $file (@bamfiles) {
    # Extracting the base name for the output file using substitution regular expression
    (my $base = $file) =~ s/_1\.fastq\.gz//; # substitute the pattern found in between "/ / with nothing"

    # Constructing the cutadapt command

    my $cutadapt = "cutadapt -j=1 --output=trimmed_${base}_1.fastq.gz ".
              "--paired-output=trimmed_${base}_2.fastq.gz ".
             "--error-rate=0.1 --times=1 --overlap=3 ".
              "--action=trim --minimum-length=20 --pair-filter=any ".
              "--quality-cutoff=20 ${base}_1.fastq.gz ${base}_2.fastq.gz ".
        "> trimmed_${base}_cutadapt.log"; # "" and . for better readibility instead of one long string

    # Execute the command
    system($cutadapt) == 0
        or die "Failed to execute cutadapt: $!";
}

