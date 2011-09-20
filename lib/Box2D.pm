package Box2D;

use warnings;
use strict;
our @ISA = qw(Exporter);

=head1 NAME

Box2D - 2D Physics Library

=head1 SYNOPSIS

 use Box2D;

=head1 DESCRIPTION

Box2D is a package of Perl modules that provide an object oriented
interface to the L<Box2D Physics Engine|http://www.box2d.org/> for
Perl 5.

=head1 OVERVIEW

Currently this module is a 1 to 1 binding. This is still a WIP and so far here are the completed class:

	b2AABB
	b2Body
	b2BodyDef
	b2CircleShape
	b2Contact
	b2ContactImpulse
	b2ContactListener
	b2DistanceJoint
	b2DistanceJointDef
	b2Filter
	b2Fixture
	b2FixtureDef
	b2FrictionJoint
	b2FrictionJointDef
	b2GearJoint
	b2GearJointDef
	b2Joint
	b2JointDef
	b2LineJoint
	b2LineJointDef
	b2Manifold
	b2MassData
	b2Mat22
	b2MouseJoint
	b2MouseJointDef
	b2PolygonShape
	b2PrismaticJoint
	b2PrismaticJointDef
	b2PulleyJoint
	b2PulleyJointDef
	b2RayCastCallback
	b2RayCastInput
	b2RayCastOutput
	b2RevoluteJoint
	b2RevoluteJointDef
	b2Shape
	b2Transform
	b2Vec2
	b2WeldJoint
	b2WeldJointDef
	b2World

=head2 USAGE

Have a look at the examples folder for useage examples.

The Box2D Manual and Documentation are also useful:

L<http://www.box2d.org/documentation.html>

=head2 TODO

	Documentation
	Examples
	Adding more bindings
	Inline::C Support

=head2 CONTRIBUTE

To contribute to this module please contact us on github:

L<https://github.com/PerlGameDev/Box2D-perl>

=head1 BUGS

Report bugs at
L<GitHub Issues|https://github.com/PerlGameDev/Box2D-perl/issues>

=head1 AUTHORS

=over 4

=item Kartik Thakore

=item Abram Hindle

=item Tobias Leich

=item Jeffrey T. Palmer

=item Breno G. de Oliveira

=item Zach Morgan

=back

=head1 COPYRIGHT & LICENSE

Copyright 2011 Box2D Authors as listed above, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

our $VERSION = '0.05';

require XSLoader;
XSLoader::load( 'Box2D', $VERSION );
require Exporter;

our @EXPORT_OK   = ();
our %EXPORT_TAGS = ();

use constant {

    #b2Body Type
    b2_staticBody    => 0,
    b2_kinematicBody => 1,
    b2_dynamicBody   => 2,

    #b2Shape Type
    e_unknown   => -1,
    e_circle    => 0,
    e_polygon   => 1,
    e_typeCount => 2,

};

BEGIN {
    *Box2D::b2World::SetContactListener = sub {
        if ( UNIVERSAL::isa( $_[1], "Box2D::b2ContactListener" ) ) {
            $_[0]->SetContactListenerXS( $_[1]->_getListener() );
        }
        else {
            $_[0]->SetContactListenerXS( $_[1] );
        }
    };

    *Box2D::b2World::RayCast = sub {
        my $world    = shift;
        my $callback = shift;
        if ( UNIVERSAL::isa( $callback, "Box2D::b2RayCastCallback" ) ) {
            $world->RayCastXS( $callback->_getCallback(), @_ );
        }
        else {
            $world->RayCastXS( $callback, @_ );
        }
    };
}

package    # Hide from PAUSE
    Box2D::b2Vec2;

use overload
    '+'    => '_add',
    '-'    => '_sub',
    '*'    => '_mul',
    '=='   => '_eql',
    'bool' => sub {1};

sub _add {
    my ( $self, $other ) = @_;

    return Box2D::b2Math::b2AddV2V2( $other, $self );
}

sub _sub {
    my ( $self, $other, $swap ) = @_;

    if ($swap) {
        return Box2D::b2Math::b2SubV2V2( $other, $self );
    }
    else {
        return Box2D::b2Math::b2SubV2V2( $self, $other );
    }
}

# Multiplication is defined between a vector and scalar. Multiplying two
# vectors is ambiguous because either cross product or dot product may
# be intended. Use b2CrossV2V2 or b2DotV2V2 for those operations.
sub _mul {
    my ( $self, $other ) = @_;

    return Box2D::b2Math::b2MulSV2( $other, $self );
}

sub _eql {
    my ( $self, $other ) = @_;

    return Box2D::b2Math::b2EqlV2V2( $self, $other );
}

1;    # End of Box2D
