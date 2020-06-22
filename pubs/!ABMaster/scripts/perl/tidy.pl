# Perl script to tidy up spaces around links. 
# Also insert a table after images to prevent too narrow of a column of text wrapping around image

($txtfile, $outfile) = @ARGV;
print "Running tidy.pl...\n   In:  '$txtfile'\n   Out: '$outfile'\n";

open IN, $txtfile or die "Unable to open input file: $txtfile\n";
read IN, $_, -s $txtfile;

# Do all the global substitutions.  Syntax:  s/findregex/replacepattern/g;

s/(\<a [^>]*\>)\s+/$1/g;       # Trim leading space inside link
s/\s+(\<\/a\>)/$1/g;           # Trim trailing space inside link
s/(<\/a>)(\w)/$1 $2/g;       # Insert missing space between link and following word
s/(\w)(<a )/$1 $2/g;         # Insert missing space between word and following link
s/(\[<em>)\s+(<a [^>]+>[^<]+<\/a>)\s+(<\/em>\])/$1$2$3/g; # Trim space inside Read More brackets

# Also insert a table after images to prevent too narrow of a column of text wrapping around image
s/<\/table><!\[endif\]--><\/p>/<\/table><![endif]--><\/p><table style="width: 10em;"><\/table>/g;

open OUT, ">$outfile" or die "Unable to open output file: $outfile\n";
print OUT;
