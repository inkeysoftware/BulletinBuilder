# Perl script to extract images to a file list

# Parameters: infile outfile pattern
# The pattern is a regex pattern that must contain one pair of grouping parentheses that identifies the filename.

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.

($infile, $outfile, $pattern) = @ARGV;
unless ($pattern) { $pattern = '<img [^>]*\bsrc="[^"]*?([^\\/"]*)"' }  # Default pattern is for html <img> tag
print "Making image list from $infile to $outfile\n";

open IN, $infile or die "Unable to open input file: $infile\n";
read IN, $_, -s $infile;
close IN;

while (/$pattern/gi) { $image{$1} = 1; }

open OUT, ">$outfile" or die "Unable to write to image list: $outfile\n";
print OUT join("\n", sort keys %image);
close OUT;

