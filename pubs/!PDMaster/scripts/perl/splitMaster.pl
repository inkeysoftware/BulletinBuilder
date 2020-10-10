# Split a master file, generated from Google Docs, into content.txt, calendar.txt, etc.
# usage: perl splitMaster.pl MasterFile ProjectFolder outputfolder
# Parameters:
#    MasterFile:   Full path of the master file.
#                  Any asterisk in the path will be replaced with the project base name. e.g. 2017-03
#   ProjectFolder: Folder containing project. e.g. C:\AsiaBulletin\trunk\data\2017-03
#   OutputFolder:  Where to write split files to.  e.g. C:\AsiaBulletin\trunk\data\2017-03\temp
#   AddInvisibleChars:  Whether to add invisible chars to headings. (Needed if going on a Confluence wiki.)
#
# If a target file was modified more recently than the master file, it will not be overwritten. 
# Instead, a warning will be displayed.

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.

sub modTitle {
# Modify Title to contain invisible characters that encode the sequence number
# See Google Sheet "Unique Page Name Encoding"
	$title = $_[1];
	$len = length($title);
	$insertionPoint = ($seq % ($len - 1)) + 1;
	$ctInvis = int( $seq / ($len-1)) + 1;
	$numRightChars = $len - $insertionPoint;
	return $_[0] . substr($title, 0, $insertionPoint) . (chr(65279) x $ctInvis) . ($numRightChars > 0 ? substr($title, -1 * $numRightChars) : '') . "\n"
}

sub pdie {  # because only stdout is visible to user
   print $_[0];
   die "\n";
}

($master, $projectFolder, $outputFolder, $addInvisibleChars) = @ARGV;
print "Running splitMaster...\n";

pdie "Project folder not found: \"$projectFolder\"\n" unless -d $projectFolder;

# Identify base of project folder path
if ($projectFolder =~ /([^\\\/]+)[\\\/\s]*$/) {
	$base = $1;
} else {
	pdie "Unable to identify base folder in '$projectFolder'\n";
}

# Replace * in the master filename with the project base name.
$master =~ s/\*/$base/g;

pdie "Master file not present: \"$master\"\n" unless -e $master;
print "   Master file:    $master\n";
print "   Issue folder:   $projectFolder\n";
#print "   Output folder:  $outputFolder\n";
$builderFolder = $projectFolder;
$builderFolder =~ s/(.*)[\/\\]issues[\/\\].*/$1/ or pdie "Fatal error: project folder was expected to be a sub-folder of \\issues\\ \n";
$syncFolder = $master;
$syncFolder =~ s/[\/\\][^\/\\]+$// or pdie "Fatal error: Sync folder was expected to be specified in masterfile name \n";

# Split master file into project files
my $mtime = (stat($master))[9];
open IN, $master or pdie "Unable to open master file: $master\n";
$curOut = "";
$seq = 0;
while (<IN>) {
	if (/^===(\S+)===\s*$/) {			# ===FILENAME=== marks beginning of content for filename.txt
		$outfilebase = lc $1;
		$outfile = "$outputFolder\\$outfilebase.txt";
		if ($outfilebase eq 'sequence') {
			while ($seq = <IN>) {
				chomp $seq;
				last if $seq;
			}
			next;
		} 
		if ($curOut) {	# If we were writing a file, close that and timestamp it.
			close OUT;
			utime $mtime, $mtime, $curOut; 
		}
		# if (-e $outfile and (-M $outfile < -M $master)) {  # Avoid overwriting newer file
			# print "\nWARNING: $outfilebase.txt is newer than master file. Skipping.\n\n";
			# $curOut = "";
			# sleep 3;
		# } else {
			print "writing $outfilebase\n";
			$curOut = $outfile;
			open OUT, ">$curOut" or pdie "Unable to write to file: $outfile\n";
		# }
	} else {
		if ($curOut) { 
			if (/^#{5} block:\s*(\S.*?)\s*$/i) {
				$blockFN = "$syncFolder\\Resources\\Common\\Block.$1.txt";
				open BLOCK, $blockFN or pdie "Unable to open $blockFN.\nFile contained $&\n";
				read BLOCK, $stuff, -s BLOCK;
				close BLOCK;
				$_ = $stuff;
			}
			if ($outfilebase eq 'content' and /^#{1,2} /) {   # Remove any asterisk or underscore from headings that will be page titles.
				s/[*_]//g;
			}
			if ($outfilebase eq 'content' and /^#{1,2} / and $addInvisibleChars) {
				s/^(#{1,2}\s+)(.*?)\s*\n/modTitle($1,$2)/e;
			}
			print OUT; 
		}						# Output the current line to the current output file
	}
}
if ($curOut) {	# If we were writing a file, close that and timestamp it.
	close OUT;
	utime $mtime, $mtime, $curOut; 
}
