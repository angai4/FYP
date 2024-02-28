#!/usr/bin/perl
use strict;
use warnings;

# This script will index bam files within the current directory

# -@ specify number of threads to use
for i in *Aligned.sortedByCoord.out.bam; do
samtools index $i -@ 12
done

foreach 
