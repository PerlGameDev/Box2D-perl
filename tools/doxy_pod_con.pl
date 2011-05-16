use strict;
use warnings;

my $c_file_path = $ARGV[0];

die "Need a c++ file to read" unless $c_file_path;

open(my $FH, '<', $c_file_path);

while(<$FH>)
{
#	chomp;

	print "$1 \n $4 \n\n" if( $_ =~ /([\/]+[^\n]+)+\n(.+)/m );
}

close $FH;

