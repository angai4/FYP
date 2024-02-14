#!/bin/bash

# This code will extract a subset of reads from gzipped fastq files and output them to new subset gzipped fastq files and remove the original files
# Working with subset FASTQ files will allow for faster script testing/development

# Number of reads to extract
num_reads=100  # Number of reads you want to extract
# Each read consists of 4 lines in a FASTQ file
let lines_to_extract=$num_reads*4

# Loop through all gzipped FASTQ files in the current directory
for file in *.fastq.gz; do
    # Extract the base name without .fastq.gz
    base_name="${file%.fastq.gz}"
    # Define the output filename using the extracted base name
    output_name="subset_${base_name}.fastq.gz"

 # Use zcat to decompress and stream the input, head to extract the first N lines,
    # and gzip to compress the output stream to the desired output file
    zcat "$file" | head -n $lines_to_extract | gzip > "$output_name"
   echo "Extracted $num_reads reads from\
 $file to $output_name"

 # Remove the original gzipped FASTQ file
   rm $file
   echo "Removed original file: $file"
done


