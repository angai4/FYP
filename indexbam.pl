#!/usr/bin/perl
use strict;
use warnings;

# This script will index bam files within the current directory

# -@ specify number of threads to use
for i in *Aligned.sortedByCoord.out.bam; do
samtools index $i -@ 12
done

# Getting all the files matching the pattern *_1.fastq.gz
my @files = glob("*_1.fastq.gz");

foreach my $file (@files) {
    # Extracting the base name for the output file using substitution regular express\
ion
    (my $base = $file) =~ s/_1\.fastq\.gz//; # substitute the pattern found in betwee\
n "/ / with nothing"

    # Constructing the cutadapt command

    my $cutadapt = "cutadapt -j=1 --output=trimmed_${base}_1.fastq.gz ".
              "--paired-output=trimmed_${base}_2.fastq.gz ".
             "--error-rate=0.1 --times=1 --overlap=3 ".
              "--action=trim --minimum-length=20 --pair-filter=any ".
              "--quality-cutoff=20 ${base}_1.fastq.gz ${base}_2.fastq.gz ".
        "> trimmed_${base}_cutadapt.log"; # "" and . for better readibility instead o\
f one long string

    # Execute the command
    system($cutadapt) == 0
        or die "Failed to execute cutadapt: $!";
}

