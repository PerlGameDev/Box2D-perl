package Box2D::b2ContactListener;
use strict;
use Box2D;
=head1 NAME

Box2D::b2ContactListener - 2D Physics Library Contact Listener

=cut

BEGIN {
 
#    { #make a new scope for the wrapper;
#        *Box2D::b2World::SetContactListenerXS = *Box2D::b2World::SetContactListener;
#        *Box2D::b2World::SetContactListener = sub {
#            my ($self, $listener) = @_;
#            if (UNIVERSAL::isa($listener,"Box2D::b2ContactListener")) {
#                Box2D::b2World::SetContactListenerXS( $self, $listener->_getListener() );
#            } else {
#                Box2D::b2World::SetContactListenerXS( $self, $listener );
#            }
#        };
#    }
}
#use base qw(Box2D::PerlContactListener);

# this class is a wrapper for the PerlContactListener 
# to allow you to make b2ContactListeners via inheritance

=head1 METHODS

=head2 Creation

=over 4

=item new Box2D::b2ContactListener

Creates and returns a new b2Contactlistener. This is an inheritance friendly
sub so you're free to leave it as default. Remember to call super in your own 
code, don't forget to call this!

=cut

sub new {
    my($class) = @_; 
    my $self = { };
    bless($self, $class);          # Say: $self is a $class
    $self->{_listener} = Box2D::PerlContactListener->new();
    $self->setOurListeners();
    return $self;
}

=pod

=back

=head2 Listener Methods

=over 4

=item $listener->BeginContact( $contact )

=cut

# overload these
sub BeginContact {}

=pod

=item $listener->EndContact( $contact )

=cut

sub EndContact {}

=pod

=item $listener->PreSolve( $contact, $manifold )

=cut


sub PreSolve {}

=pod

=item $listener->PostSolve( $contact, $impulse )

=cut

sub PostSolve {}

=pod

=item $listener->setOurListeners()

This is private don't bother calling it unless you inherit and need to initialize.
$self->{_listener} needs to be a PerlContactListener

=cut

# this will make sure that the right subs are set
sub setOurListeners {
    my ($self) = @_;
    $self->{_listener}->SetBeginContactSub( sub { $self->BeginContact(@_); } );
    $self->{_listener}->SetEndContactSub( sub { $self->EndContact(@_); } );
    $self->{_listener}->SetPostSolveSub( sub { $self->PostSolve(@_); } );
    $self->{_listener}->SetPreSolveSub( sub { $self->PreSolve(@_); } );
}

sub _getListener {
    my ($self) = @_;
    return $self->{_listener};
}

=pod

=cut

1;
