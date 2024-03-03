#!/usr/bin/perl
use strict;
use warnings;

my $genebody_dir = "$ENV{HOME}/automation/coordinate_sorted_bams/rseqc/genebodycoverage";
my $bam_path = "$ENV{HOME}/automation/coordinate_sorted_bams";

chdir $bam_path or die "Cannot change to directory $bam_path: $!";
print "Successfully changed to directory: $bam_path\n";

# Getting all the files matching the pattern *Aligned.sortedByCoord.out.bam
my @files = glob("*Aligned.sortedByCoord.out.bam");

my $total_count = 0;
my $file_count = 0;

foreach my $file (@files) {

    my $count = `samtools view -c $file`;
    chomp $count;
    print "Count for file $file is: $count\n";

    if ($count =~ /^\d+$/) {
        $total_count += int($count);
        $file_count++;
    } else {
    print "Non-numeric count for file $file: $count\n";
    }
}

if ($file_count > 0) {
    my $average_count = $total_count / $file_count:
    print "Average count of alignments: $average_count\n";
} else {
    print "No files processed, unable to calculate average.\n";
}

# practice to create a subsample with 100 reads -s = want / avg
my $s = 100 / $average_count
foreach my $file (@files) {

    # Extracting the base name for the output file using substitution regular expression
    (my $base = $file) =~ s/Aligned\.sortedByCoord\.out\.bam//; # substitute the pattern found in between "/ / with nothing"

    system("samtools view -s $x -o ${base}Aligned.sortedByCoord.out_subset.bam $file");
    print "Successfully subsampled a proportion of aligned reads for $file\n";
    }
