# Perl script to convert HTML to content suitable for wiki

# Parameters: ($infile, $outfolder, $issueID, $spaceKey) = @ARGV;
#       $infile    = untrimmed html file
#       $outfilebase = path and base of output files
#       $issueID   = Name of issue  e.g. "2020-07"
#       $spaceKey  = Name of space on Confluence wiki  e.g. "AB"

$spaceKey = 'AB';  # Setting used in Next link in Asia Bulletin space

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.

sub escHtml {
  my ($txt) = @_;
  $txt =~ s/&/&amp;/g;
  $txt =~ s/"/&quot;/g;
  $txt =~ s/'/&#39;/g;
  $txt =~ s/</&lt;/g;
  $txt =~ s/>/&gt;/g;
  return $txt;
}

sub escEsc {
  my ($txt) = @_;
  $txt =~ s/&/░amp;/g;
  $txt =~ s/"/░quot;/g;
  $txt =~ s/'/░#39;/g;
  $txt =~ s/</░lt;/g;
  $txt =~ s/>/░gt;/g;
  $txt =~ s/\x{FEFF}/▤/g;
  return $txt;
}

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

sub getArticle {	 # This function is passed an article's body, tail, and next article.
		 # It returns the code needed for the wiki page. 
	my ($body, $tail, $next) = @_; 	# Parameters passed to this function
	
	# Delete <!-- ... --> comments
	$body =~ s/<!--.*?-->//g;		
	
	# Delete empty table used for wrapping control
	$body =~ s/<table style="width: \w+;"><\/table>//g;
	
	# Replace image format where link is present
	$body =~ s/class="(float-)?(left|right|center)">[\s\n]*(<a href=[^>]+>)<img src="img\/(.*?)" alt=""(?: id="")?\/>(<\/a>)/>$3<ac:image ac:align="$2" ac:thumbnail="true"> <ri:attachment ri:filename="$4"><ri:page ri:content-title="$issueID"\/><\/ri:attachment><\/ac:image>$5/g;
	# Replace image format without link
	$body =~ s/class="(float-)?(left|right|center)">[\s\n]*<img src="img\/(.*?)" alt=""(?: id="")?\/>/><ac:image ac:align="$2" ac:thumbnail="true"> <ri:attachment ri:filename=\"$3\"><ri:page ri:content-title=\"$issueID\"\/><\/ri:attachment><\/ac:image>/g;
	
	# "<ri:attachment ri:filename=\"$3\"><ri:page ri:content-title=\"$issueID\"/></ri:attachment>"
	
	# To do: Make main part and excerpt, based on readmore link if present. 
	# Read More link will become like this in the Wiki: 
	#        [<em><ac:link><ac:plain-text-link-body><![CDATA[Read More]]></ac:plain-text-link-body></ac:link></em>]
	###[<em><a href="readmore">Read more</a></em>]
	#-------------->
	# Change it to:  (from Wiki w/ excerpt Macro)
	#-------------->
	#<ac:structured-macro #ac:macro-id="749fecbc-f979-4ffa-a558-e32f8b9cb7b4" #ac:name="excerpt" ac:schema-version="1">
	#  <ac:parameter ac:name="hidden">true</ac:parameter>
	#  <ac:parameter #ac:name="atlassian-macro-output-type">INLINE</ac:parameter>
	#  <ac:rich-text-body>
	#    <p>
	#        <ri:content-entity ri:content-id="219546000"/>
	#        <ac:link-body>[<em>Read More</em>]</ac:link-body>
	#      </ac:link>
	#	 </p>
	#  </ac:rich-text-body>
	#</ac:structured-macro>
	
	# ?? https://www.regular-expressions.info/examplesprogrammer.html  
	# Get from beginning to Read More or end; becomes body & excerpt

	#defining the next link
	# <p><strong><span style="color: rgb(255,102,0);">Next:</span></strong><ac:link><ri:page ri:content-title="Northern Thai NT"/></ac:link></p>
	
	$nextEsc = escHtml($next);
	# $nextEsc =~ s/\&/\&amp;/g;
	$nextcode = $next ? '<p><strong><span style="color: rgb(255,102,0);">Next: </span></strong><ac:link><ri:page ri:content-title="' . $nextEsc . '" ri:space-key="' . $spaceKey . '"/><ac:plain-text-link-body><![CDATA[' . $next . ']]></ac:plain-text-link-body></ac:link></p>'."\n" : "";
	# defining beginning of macro
	#<ac:structured-macro ac:macro-id="c3a3d273-bdde-4a66-b140-46175963f3dc" ac:name="excerpt" ac:schema-version="1"><ac:parameter ac:name="hidden">true</ac:parameter><ac:parameter ac:name="atlassian-macro-output-type">INLINE</ac:parameter>  <ac:rich-text-body>
	$excerptbegin = '<ac:structured-macro ac:macro-id="c3a3d273-bdde-4a66-b140-46175963f3dc" ac:name="excerpt" ac:schema-version="1"><ac:parameter ac:name="hidden">true</ac:parameter><ac:parameter ac:name="atlassian-macro-output-type">INLINE</ac:parameter>  <ac:rich-text-body>' . "\n"; 
	$wikilinkstart = '[<em><ac:link><ac:plain-text-link-body><![CDATA[';
	$wikilinkend = ']]></ac:plain-text-link-body></ac:link></em>]' . "\n";
	$excerptend = '</ac:rich-text-body></ac:structured-macro>' . "\n";

	#$body =~ s/(^.* readmore|.$)/$1/g;
	#$body = $1 . "<ac:structured-macro ac:macro-id=\"749fecbc-f979-4ffa-a558-e32f8b9cb7b4\" ac:name=\"excerpt\" ac:schema-version=\"1\">" . $1 . "<\/ac:structured-macro> ";
	if ($body =~ /(^.*?)(…\s*)?\[\s*(?:<em>)?\s*<a href="(?:http:\/\/)?(?:readmore|comment)">(.*?)<\/a>\s*(?:<\/em>)?\s*\]\s*(.*)/is) {
		$pre = $1;  # Basically, everything that comes before the [Read more] except optional elipsis
		$elipsis = $2;  # optional elipsis
		$linktext = $3; # e.g. "Read more"
		$post = $4; 
		
		#$body = "$pre$link\">$2</a></em>]\n";	
		return $pre . $post . $tail . $nextcode . $excerptbegin . $pre . $elipsis . $wikilinkstart .$linktext . $wikilinkend . getMissingCloseTags($pre) . "\n" .$tail . $excerptend  ;
	}
	if ($body =~ /(^.*?)((?:…\s*)?\[\s*(?:<em>)?\s*<a href="(?:http:\/\/)?fullarticle">(.*?)<\/a>\s*(?:<\/em>)?\s*\]\s*[.\n]*?\s*<\/p>)(.*)/is) {
		$pre = $1;
		$link = $2;
		$linktext = $3;
		$post = $4;
		
		#$body = "$pre$link\">$2</a></em>]\n";	
		return $post . $tail . $nextcode . $excerptbegin . $pre . $wikilinkstart .$linktext . $wikilinkend . "</p> \n" .$tail . $excerptend  ;
	}
	if ($body =~ /href="(?:http:\/\/)?(readmore|comment|fullarticle)/is) {
		return ("*" x 80) . "\nBUG in $0: $1 link found in this article should have been matched by regex!!!\n$body\n"
	}
	return $body . $tail . $nextcode . $excerptbegin . $body . $tail . $excerptend  ;
	
}

($infile, $outfilebase, $issueID, $spaceKey) = @ARGV;
$outfiletxt = "$outfilebase.txt";
$outfilehtml = "$outfilebase.html";
$outfileimg = "$outfilebase-imagelist.txt";
print "Running MakeWikiPages.pl...\n   In:   '$infile'\n   Out: '$outfilebase*'\n";

open IN, $infile or die "Unable to open input file: $infile\n";
read IN, $_, -s $infile;

s/<\/div>[\s\n]*<!-- main content ends before this-->.*//s; # Delete content after articles

# s/<h4.*?>/<sup>/g;		# Replace <h4> with <sup>
# s/<\/h4>/<\/sup>/g;

foreach $i (/(?<=<img src="img\/).*?(?=")/g) { $image{$i} = 1; }
open IMG, ">$outfileimg" or die "Unable to write to image list: $outfileimg\n";
$outfiletxt =~ /[^\\\/]+$/;
print IMG "$&\n";
print IMG join("\n", sort keys %image);
close IMG;

@sections = split /(?=<h[12]\b)/;
shift @sections;	# drop the part that comes before the first section

foreach $_ (@sections) {
	s/^<h([12]\b)[^>]*>([^<\r\n]+).*?<\/h[12]>[\s\r\n]*//s  # Remove heading 
		|| die "Unexpected section heading format: " . substr($_, 0, 100);
	$headnum = $1;
	$head = $2; # Remember article's title 
	$head =~ s/&amp;/&/g;
	$head =~ s/&lt;/\</g;
	$head =~ s/&gt;/\>/g;
	push @heads, $head; 
	if ($headnum == 1) {  		# if it's <h1>
		$level1 = $head;		# 	remember this as the top-level heading for those that come beneath
		$level{$head} = "TOP";
	} else {
		$level{$head} = $level1;	#	otherwise remember which top-level this came beneath
	}
	
	unless (/\S/) {
		# This is just a section heading
		$type{$head} = "S";
		next;
	}
	$type{$head} = "A";
	$tail{$head} = (s/<h4 [^>]*>(.*?)<\/h4>[\s\r\n]*//s) ? "<p><sup>$1</sup></p>\n" : "";
	$body{$head} = $_;
	#$images{$head} = join "\t", /(?<=<img src="img\/).*?(?=")/g;
}

# Remember which article is next for each article
$next{$head} = ""; # Final article has no next
$nextArticle = $head;
for ($i=$#heads-1; $i>=0; $i--) {
	if ($type{$heads[$i]} eq "A") {
		$next{$heads[$i]} = $nextArticle;
		$nextArticle = $heads[$i];
	}
}

# First output the upload version


sub preparedForUpload {
   my ($txt) = @_;
   $txt =~ s/\n/ /g;
   $txt =~ s/ {2,}/ /g;
   return escEsc($txt);
}

$formatVersion = "4";
push @pages, "$formatVersion▒$issueID▒UsePage:BBTemplate-Issue";
foreach $head (@heads) {
	$pgBody = ($type{$head} eq "S") ? "UsePage:BBTemplate-Section" : getArticle($body{$head}, $tail{$head}, $next{$head});
	$parent = ($level{$head} eq 'TOP') ? $issueID : $level{$head};
	push @pages, "$parent▒$head▒▒$pgBody";
}
# $uploadContents = "<p>" . preparedForUpload(join("▓▓", @pages)) . "</p>";
$uploadContents = join("▓", @pages);
open OUT, ">$outfiletxt" or die "Unable to open output file: $outfiletxt\n";
print OUT chr(65279);
print OUT $uploadContents;
close OUT;

# Now do HTML version
$outfile =~ s/\.txt$/.html/i;
open OUT, ">$outfilehtml" or die "Unable to open output file: $outfilehtml\n";
print OUT chr(65279);  # BOM
print OUT "<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"utf-8\" lang=\"utf-8\"><body>\n";
print OUT '<hr><p>To manually update individual pages, you can copy and paste page titles and contents from the table below:</p>';

$ct = 0;
foreach $head (@heads) {
	$ct++;
	# print OUT "<hr>\n";
	if ($type{$head} eq "S") {
		print OUT "<table style=\"background-color: lightblue; border: 2px black solid;\">\n"
		         ."<tr><th><button id=\"button\" onclick=\"copyTextArea('TA$ct')\">Section:</button></th>\n"
		         ."<td><textarea id=\"TA$ct\" rows=\"1\" cols=\"90\">$head</textarea></td>"
		         ."</tr>\n"
		         # ."<tr><th>Under:</th><td>$level{$head}</td></tr>\n"
		         ."</table>\n";
	} else {
		if ($level{$head} eq 'TOP') {
		   $color =  'lightgreen';
		   $level = '(at top level)';
		   $indent = '';
		} else {
		   $color = 'lightyellow';
		   $level = "(under $level{$head})";
		   $indent = 'margin-left:5em;'
		}
		print OUT "<table style=\"background-color: $color; border: 1px black solid; $indent\">\n"
		         ."<th><button id=\"button\" onclick=\"copyTextArea('TA$ct')\">Article:</button></th>\n"
		         ."<td><textarea id=\"TA$ct\" rows=\"1\" cols=\"90\">$head</textarea></td></tr>\n"
		         # . (($images{$head}) ? "<tr><th>Images:</th><td>$images{$head}</td></tr>\n" : "")
		         ."<tr><th><button id=\"button\" onclick=\"copyTextArea('TAC$ct')\">Contents:</button></th><td><textarea id=\"TAC$ct\" rows=\"2\" cols=\"90\">" . escHtml(getArticle($body{$head}, $tail{$head}, $next{$head})) . "</textarea></td>"
		         ."</tr>\n"
		         ."</table>\n";
	}
	# $contents .= "\n\n";
}
print OUT '<script>function copyTextArea(id) { document.getElementById(id).select(); document.execCommand("copy"); } </script></body></html>';
close OUT;
