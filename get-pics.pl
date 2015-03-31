#!perl

use strict;
use warnings;
use Mojo::Base -base;
use Getopt::Long;
use List::AllUtils qw/natatime/;
sub DEBUG { 1 }

GetOptions(
    'days' => \(my $days = 0),
    'hours' => \(my $hours = 1),
) or die("Error in command line arguments\n");

say 'Fetching file list (this usually takes some time)';
my $files = `mtp-files`;
if (DEBUG) {
    say "$files\n\n";
    open my $fh, '>', 'out.txt' or die $!;
    say $fh $files;
}

my $iter = natatime(
    2,
    $files =~ / ID: \s+ (\d+) .+? Filename: \s+ (\S+\.(?:jpg|png)) /xsg
);

my @files;
while ( my @vals = $iter->() ) { push @files, join ' ', @vals; }

my ( $year, $month, $day, $hour ) = (localtime)[5, 4, 3, 2];
$year += 1900;
$month = sprintf '%02d', $month+1;

# I'm too lazy to support checking whether we rolled over, so... meh
my $hour_re = $hours ? qr/(?:$hour|${\($hour-1)})/x : qr/\d{2}/;
my $day_re  = $days  ? qr/(?:$day |${\($day -1)})/x : qr/\d{2}/;

my $screenshot_re = qr/^\d+ Screenshot_$year-$month-$day_re-$hour_re/;
my $pic_re        = qr/^\d+ $year$month${day_re}_$hour_re/;

if (DEBUG){ say for "Originals:", @files, $screenshot_re, $pic_re; }
@files = grep /$screenshot_re/ || /$pic_re/, @files;

say "Gonna fetch these files:\n@files";

for ( @files ) {
    say "Gettting $_";
    system 'mtp-getfile', split ' ', $_, 2;
}


__END__

File ID: 1103
   Filename: Screenshot_2015-03-27-07-03-32.png


File ID: 101
   Filename: 20150215_162323.jpg
