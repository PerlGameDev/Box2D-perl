package Box2D::b2RayCastCallback;
use strict;
use warnings;
use Box2D;

sub new {
    my($class) = @_;

    my $self = { _callback => Box2D::PerlRayCastCallback->new() };

    return  bless $self, $class;
}

1;

=head1 NAME

Box2D::b2RayCastCallback

=head1 SYNOPSIS

    my $callback = Box2D::b2RayCastCallback->new();

=head1 METHODS

=head2 new

    my $callback = Box2D::b2RayCastCallback->new();

=cut
