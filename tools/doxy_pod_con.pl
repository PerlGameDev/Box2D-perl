use strict;
use warnings;

my $c_file_path = $ARGV[0];

die "Need a c++ file to read" unless $c_file_path;

open(my $FH, '<', $c_file_path);
my $file = '';
while(<$FH>) {
    $file .= $_;
}
close $FH;


my @matches = $file =~ /(\/\/\/+[^\n]+)+\n([^\n]+\s[^\n]+;)/gm;

my $comments;
my $function;
foreach(@matches)
{
	chomp;
	$_ =~ s/\\m//g;
	print $_."\n";

=pod
	if( $_ =~ /(\/\/\/)(.*)/ )
	{
		$comments .= $2."\n";	
	}
	else
	{
		if( $comments )
		{
		$function = $_;

		print "=head2 $function \n$comments \n";

		$comments = '';
		}

	}
=cut 
}
