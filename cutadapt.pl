#!/usr/bin/perl
use strict;
use warnings;
use File::Path 'make_path';

my $dir = "$ENV{HOME}/automation/trimmed_fastq/FastQC";

# The make_path function will create the directory and any necessary parent directori\
es
make_path($dir);

# Define the directory you want to change to
my $directory = "$ENV{HOME}/automation/raw_fastq";

# Change to the specified directory
chdir $directory or die "Cannot change to directory $directory: $!";

print "Successfully changed to directory: $directory\n";

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

# move trimmed data - open the source directory
opendir(my $dh, $directory) or die "Cannot open directory $directory: $!";

while (my $file = readdir($dh)) {
    # If the file starts with "trimmed", move it to the target directory
    if ($file =~ /^trimmed/) {
        my $source_path = "$directory/$file";
        my $target_path = "$ENV{HOME}/automation/trimmed_fastq/$file";
        rename($source_path, $target_path) or die "Cannot move $source_path to $targe\
t_path: $!";
    }
}

closedir($dh);

# Change to directory you want multiqc to end up in

my $mqcdirectory = "$ENV{HOME}/automation/trimmed_fastq";
chdir $mqcdirectory or die "Cannot change to directory $mqcdirectory: $!";
print "Successfully changed to directory: $mqcdirectory\n";

# Run MultiQC on the cutadapt logs

my $multiqc_cmd = "multiqc $mqcdirectory -n cutadapt_multiqc";
system($multiqc_cmd) == 0 or die "Failed to run MultiQC: $!";

# Run fastqc on the trimmed fastq files

# Get a list of FASTQ files
my @fastq_files = glob("*.fastq.gz");

foreach my $file (@fastq_files) {
    # Run FastQC
    my $fastqccmd = "fastqc --outdir=$dir $file";
        print "Running: $fastqccmd\n";
    system($fastqccmd) == 0 or warn "Failed to run $fastqccmd: $!";
}

print "FastQC analysis complete.\n";

# Run multiqc on trimmed fastqc files

my $multiqc_cmd2 = "multiqc $dir -n trimmed_fastqc_multiqc";
system($multiqc_cmd2) == 0 or die "Failed to run MultiQC: $!";
