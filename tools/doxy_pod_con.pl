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

    if ( $title =~ m#Box2D: (\w+) (Class|Struct) Reference#ms ) {
        $class->{name} = $1;
    }
    else {
        $class->{name} = 'TODO';
    }

    $class->{description} = $tree->findvalue('//div[@class="contents"]/p[4]');

    # Use the first sentence from the description for the abstract
    if ( $class->{description} =~ /^((?:.*?)\.)/xs ) {
        $class->{abstract} = $1;
    }
    else {
        $class->{abstract} = 'TODO';
    }

    $class->{methods} = parse_methods( $class, $tree );

    return $class;
}

sub parse_methods {
    my ( $class, $tree ) = @_;

    my @methods;

    my @members = $tree->findnodes('//div[@class="memitem"]');

    foreach my $member (@members) {

        my ( $type, $name )
            = parse_method_name(
            $member->findvalue('.//td[@class="memname"]') );

        my $desc = $member->findvalue('.//div[@class="memdoc"]');

        next if $name =~ m/\[protected\]/;
        next if $name =~ m/\[friend\]/;

        if ( $type && $type ne 'void' ) {
            $type = "Box2D::$type" if $type =~ /^b2/;
            $desc .= "\n\nReturns a $type";
        }

        if ( $name eq $class->{name} ) {
            $name = 'new';
            $desc = 'Constructor';
        }

        my @p_types
            = $member->findnodes_as_strings('.//td[@class="paramtype"]/a');
        my @p_names = map { '$' . $_ }
            $member->findnodes_as_strings('.//td[@class="paramname"]/em');

        $name .= '( ' . join( ', ', @p_names ) . ' )' if @p_names;

        my @args;

        for ( 0 .. $#p_types ) {
            push @args, { type => $p_types[$_], name => $p_names[$_] };
        }

        my %method = (
            name        => $name,
            description => $desc,
            arguments   => \@args,
        );

        push @methods, \%method;
    }

    return \@methods;
}

sub parse_method_name {
    my ($name) = @_;

    # Parse things like:
    #   float Class::Method
    #   Class * Class::Method
    my $regex = qr/
        ^
        \s*
        (?:
            (\w+)           # return type
            \s+
            (?: \* \s+)?    # possibly a pointer
        )?
        (?: \w+ )           # class name
        ::
        (\w+)               # method name
        \s*
        $
    /x;

    if ( $name =~ $regex ) {
        return ( $1, $2 );
    }
    else {
        return ( '', $name );
    }
}

sub output_pod {
    my ($class) = @_;
    my $tt = Template->new() or die "$Template::ERROR\n";
    $tt->process( \*DATA, $class ) or die $tt->error(), "\n";
}

main(@ARGV);

__END__

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

Report bugs at https://github.com/PerlGameDev/Box2D-perl/issues

=head1 AUTHORS

See L<Box2D/AUTHORS>

=head1 COPYRIGHT & LICENSE

See L<Box2D/"COPYRIGHT & LICENSE">
[% IF see_also %]

=head1 SEE ALSO

[% see_also %]

[% END %]
=cut
