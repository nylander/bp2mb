#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  pb2mb.pl
#
#        USAGE:  ./pb2mb.pl file.trees
#
#  DESCRIPTION:  Tries to convert the output from BayesPhylogenies (http://www.evolution.reading.ac.uk/BayesPhy.html)
#                to a format similar to the output from MrBayes v.3 (http://www.mrbayes.net).
#                A new file with the file ending '.MB.t' will be created in the cwd.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Johan A. A. Nylander (JN), <johan.nylander @ abc.se>
#      COMPANY:  Dept Botany, SU / SCS, FSU
#      VERSION:  1.0
#      CREATED:  12/12/2008 03:22:44 PM CET
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Getopt::Long;

my $outfile_ending = ".MB.t";

## Cheack arguments
if (@ARGV < 1) {
    print "\n Usage: $0 file1 file2 ...\n\n";
    exit(0);
}
else {
    GetOptions('help' => sub {die "Usage: $0 file1 file2 ...\n"});
}

## Read the infiles
while(@ARGV) {

    my $infile = shift;

    open my $INFILE, "<", $infile or die "could not open $infile : $!\n";

    my $outfile = $infile . $outfile_ending;

    if (-e $outfile) { # Check if output file already exists
        die "\nWarning: $outfile already exists. Cowardly refuses to overwrite and quitting.\n\n";
    }

    open my $OUTFILE, ">", $outfile or die "could not create outfile : $!\n";

    my $counter = 1;

    while (<$INFILE>) {
        my $line = $_;
        if ($line =~ /#NEXUS/i) { # Insert dummy ID
            print $OUTFILE "#NEXUS\n[ID: 0123456789]\n";
        }
        elsif ( $line =~ /^\s*tree\s+([\w\.\d]+)\s+=/i ) { # Relace tree names Note 08/16/2009 06:39:34 PM CEST: use '\S+' instead of '[\w\.\d]'?
            $line =~ s/$1/rep.$counter/;
            $counter++;
            print $OUTFILE $line;
        }
        else {
            print $OUTFILE $line;
        }
    }

    close($INFILE) or warn "could not close $infile : $!\n";
    close($OUTFILE) or warn "could not close $outfile : $!\n";

    print STDERR "wrote: $outfile\n";
}

exit(0);

