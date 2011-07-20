#!/usr/bin/env perl
use strict;
use warnings;
use Template;
use File::Slurp qw(read_file);
use HTML::TreeBuilder::XPath;

sub main {
    my ($file) = @_;

    die "Need an html file to read\n" unless defined $file;
    die "Not a file: $file\n" unless -f $file;

    my $class = parse_html($file);
    output_pod($class);
}

sub parse_html {
    my ($file) = @_;

    my $class = {};

    my $tree = HTML::TreeBuilder::XPath->new;
    $tree->parse_file($file);

    my $title = $tree->findvalue('/html/head/title');

    if ( $title =~ m|Box2D:\ (\w+)\ Class\ Reference|xms ) {
        $class->{name} = $1;
    }
    else {
        $class->{name} = 'TODO';
    }

    $class->{description} = $tree->findvalue('//a[@name="_details"]/../p[3]');

    # Use the first sentence from the description for the abstract
    if ( $class->{description} =~ /^((?:.*?)\.)/xs ) {
        $class->{abstract} = $1;
    }
    else {
        $class->{abstract} = 'TODO';
    }

    $class->{methods} = [];

    my @members = $tree->findnodes('//div[@class="memitem"]');

    foreach my $member (@members) {

        my $name = $member->findvalue('.//td[@class="memname"]');
        my $desc = $member->findvalue('.//div[@class="memdoc"]');

        next if $name =~ m/\[protected\]/;
        next if $name =~ m/\[friend\]/;

        my %method = (
            name        => $name,
            description => $desc,
        );

        push @{ $class->{methods} }, \%method;
    }

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
