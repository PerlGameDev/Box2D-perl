package Box2D::b2RayCastCallback;
use strict;
use warnings;
use Box2D;
use Carp;

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;

    $self->{_callback}
        = Box2D::PerlRayCastCallback->new( sub { $self->ReportFixture(@_) } );

    return $self;
}

sub ReportFixture {
    croak 'You must override Box2D::b2RayCastCallback::ReportFixture';
}

sub _getCallback { $_[0]->{_callback} }

1;

=head1 NAME

Box2D::b2RayCastCallback

=head1 SYNOPSIS

    package My::RayCastCallback;

    use parent qw(Box2D::b2RayCastCallback);

    sub ReportFixture {
        my ( $self, $fixture, $point, $normal, $fraction ) = @_;

        // Do something
    }

    1;

=head1 DESCRIPTION

=head1 METHODS

=head2 new

The default constructor.  If you override the constructor it is
necessary to call SUPER::new.

=head2 ReportFixture

Override this method

=cut
