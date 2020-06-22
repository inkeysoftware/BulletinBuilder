# Perl script to extract images to a file list

# Parameters: filelist paths destination

use utf8;                       # Source code is encoded using UTF-8.
use open ':encoding(utf-8)';    # Sets the default encoding for handles opened in scope.
use File::Copy;

($filelist, $paths, $destination) = @ARGV;
print "Assembling files\n\tfrom: $filelist\n\tto:   $destination\n";

@paths = split /;/, $paths;
open IN, $filelist or die "Unable to open file list: $filelist\n";
@filenames = <IN>;
close IN;

# FILENAME: while (<IN>) {
FILENAME: foreach (@filenames) {
   chomp;
   next unless /\S/;
   $dest = "$destination\\$_";
   foreach $p (@paths) {
	$src = "$p\\$_";
	if (-f $src) {
	    # if (not -e $dest) {
		# print "copy $src " 
		# copy ($src, $dest);
		# next FILENAME;
	    # }
	    # if ((not -e $dest) or ((stat($dest))[9] > (stat($src))[9]) + 2) {
		# $dest = "$destination/$_";
		# print "copy $src " . (-e $dest ? (((stat($dest))[9]) . " > " . ((stat($src))[9]) ) : "no dest") . "\n";
		# copy ($src, $dest);
		# next FILENAME;
	    # }
	    $cmd = "xcopy \"$src\" \"$destination\" /d /y /i 1>nul";
	    # print "$cmd\n";
	    system($cmd);
	    next FILENAME;
	}
   }
}
foreach (@filenames) {
   chomp;
   next unless /\S/;
   if (not -f "$destination\\$_") { push(@bad, $_) }
}

if (@bad) {
   print "Missing files:\n\t" . join("\n\t", @bad) . "\n";
   print "Please ensure these files are present in one of these locations:\n\t" . join("\n\t", @paths) . "\n";
   die "\n";
}