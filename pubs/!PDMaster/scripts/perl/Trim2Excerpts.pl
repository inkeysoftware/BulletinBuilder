# Perl script to trim the email to contain just the excerpts

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.
use URI::Escape;

sub getMissingCloseTags {  # Get any close tags that are missing, probably due to [Read More] coming before the close.
	my ($body) = @_;
	$body =~ s/<\w+[^>]*\/>//g;  # Ignore self-closing tags like <br/>
	@tags = $body =~ /(?<=<)\/?\w+/g;
	$s = ' ' . join(' ', @tags) . ' ';
	while ($s =~ / (\w+) \/\1 /) { $s =~ s/ (\w+) \/\1 / /g; }
	my $ret = '';
	foreach (reverse split /\s+/, $s) { $ret .= "</$_>" if ($_); }	 
	return $ret; 
}

sub processBody { # This function is passed an article's bare heading and body (without header or tail).
	# It returns the body shortened to the excerpt with an appropriate Read More link.
	my ($head, $body) = @_; 	# Parameters passed to this function
	$link = $wikiSpaceUrl . uri_escape_utf8($head); # The wiki link to this article
	$link =~ s/%26amp%3B/\&/g;
	$link =~ s/%26lt%3B/\</g;
	$link =~ s/%26gt%3B/\>/g;
	
	# shorten article and substitute the link
	
	if ($body =~ /(^.*?href=")(?:http:\/\/)?(?:readmore|comment|fullarticle)(">[^\]<]*?((\]|(<\/[a-z]+>))[\s\r\n]*)+)/is) {
		$body = "$1$link$2";
		$body .= getMissingCloseTags($body) . "\n";	
	}
	return $body;
}

($txtfile, $outfile, $wikiSpaceUrl) = @ARGV;
$wikiSpaceUrl .= '/' unless ($wikiSpaceUrl =~ /\/$/);
print "Running Trim2Excerpts.pl...\n   In:  '$txtfile'\n   Out: '$outfile'\n";

open IN, $txtfile or die "Unable to open input file: $txtfile\n";
read IN, $_, -s $txtfile;
close IN;

open OUT, ">$outfile" or die "Unable to open output file: $outfile\n";

s/<!-- main content ends before this-->.*//s; # Remember content after articles
$end = $&;

@sections = split /(?=<h[12]\b)/;
$start = shift @sections;	# output the part that comes before the first section
$start =~ s/&#xA;">/">/g;
$start =~ s/(href="https:\/\/gateway\.sil\.org\/display\/AB\/)(.*?)(">)/$1 . uri_escape_utf8($2) . $3/ge;  # Fix links in TOC
print OUT $start;

foreach $_ (@sections) {
	(s/^<h([12]\b)[^>]*>([^<\r\n]+).*?<\/h[12]>[\s\r\n]*//s) 
		|| die "Unexpected section heading format: " . substr($_, 0, 100);
	$head = $2; 	# Remember article's bare title 
	print OUT $&;	# Output the <h1/2> section
	
	$tail = (s/<h4\b.*//s) ? $& : "";
	print OUT processBody($head, $_) . $tail;
}
print OUT $end;
close OUT;



