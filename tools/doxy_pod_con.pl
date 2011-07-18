#!/usr/bin/env perl
use strict;
use warnings;
use Template;
use File::Slurp qw(read_file);

sub main {
    my ($path) = @_;

    die "Need an html file to read\n" unless defined $path;
    die "Not a file: $path\n" unless -f $path;

    my $file  = read_file($path);
    my $class = parse_html($file);
    output_pod($class);
}

sub parse_html {
    my ($html) = @_;

    my $class = {};

    my %re = (
        name        => qr|<title>Box2D:\ (\w+)\ Class\ Reference</title>|xms,
        description => qr|<h2>Detailed\ Description</h2>\s*<p>(.*?)</p>|xms,
    );

    while ( my ( $key, $regex ) = each %re ) {
        if ( $html =~ $regex ) {
            $class->{$key} = $1;
        }
        else {
            $class->{$key} = 'TODO';
            warn "Could not find $key\n";
        }
    }

    # Use the first sentence from the description for the abstract
    if ( $class->{description} =~ /^((?:.*?)\.)/xs ) {
        $class->{abstract} = $1;
    }
    else {
        $class->{abstract} = 'TODO';
    }

    $class->{methods} = [];

    return $class;
}

sub output_pod {
    my ($class) = @_;
    my $tt = Template->new() or die "$Template::ERROR\n";
    $tt->process( \*DATA, $class ) or die $tt->error(), "\n";
}

main(@ARGV);

__END__

=pod

=head1 NAME

Box2D::[% name %] - [% abstract %]

=head1 SYNOPSIS

  # TODO

=head1 DESCRIPTION

[% description %]

=head1 METHODS
[% FOREACH method = methods %]
=head2 [% method.name %]

[% method.description %]
[% END %]
=head1 BUGS

=head1 AUTHORS

See L<Box2D/AUTHORS>

=head1 COPYRIGHT & LICENSE

=head1 SEE ALSO

[% see_also %]

=cut
