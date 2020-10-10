# Adjust content.txt for email. Save as content2.txt

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.
use URI::Escape;

($infile, $outfile) = @ARGV;
print "Running tweakContent.pl...\n";

open IN, $infile or die "Unable to open content file: $infile\n";
read IN, $content, -s $infile;
close IN;

# Modifications looking at the whole file at once:

# TODO: Trim content after each ReadMore link
# $content =~ s///g;

$lines = '';
foreach $line (split /\n/, $content) {
	# If this line is a level 1 or 2 heading, remember the URI-encoded link to where it will be in the wiki. 
	if ($line =~ /^#{1,2}\s+(.*)/) {
		$mostRecentHeadingLink = 'https://gateway.sil.org/AB/' . uri_escape_utf8($1); 
	}

	# If this line contains a readmore or comment link, replace the link with the remembered link.
	# $line =~ s/http:\/\/(readmore|comment)\b/$mostRecentHeadingLink/ig;
	
	$lines .= $line . "\n";  # Append to what we'll write back out to the file
}
close IN;


open OUT, ">$outfile" or die "Unable to write to content2 file: $outfile\n";
print OUT $lines;
close OUT;

