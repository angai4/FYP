#!/usr/bin/perl 
use strict;
use warnings;
use File::Path 'make_path';

# This script will create the directories needed for the automation to function correctly 

# define a series of directories
my $automation_dir = "$ENV{HOME}/automation/raw_fastq"; # User must manually import their raw FastQ files within this directory

# The make_path function will create the directory and any necessary parent directories
make_path($automation_dir);
print "Successfully created the directory and any necessary parent directories\n";


