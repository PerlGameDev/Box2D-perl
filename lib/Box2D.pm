package Box2D;

use warnings;
use strict;
our @ISA = qw(Exporter);

our $VERSION = '0.06';

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

	#b2JointType
	e_unknownJoint   => 0,
	e_revoluteJoint  => 1,
	e_prismaticJoint => 2,
	e_distanceJoint  => 3,
	e_pulleyJoint    => 4,
	e_mouseJoint     => 5,
	e_gearJoint      => 6,
	e_wheelJoint     => 7,
	e_weldJoint      => 8,
	e_frictionJoint  => 9,
	e_ropeJoint      => 10,

	#b2LimitState
	e_inactiveLimit => 0,
	e_atLowerLimit  => 1,
	e_atUpperLimit  => 2,
	e_equalLimits   => 3,
};

use Box2D::b2Mat22;
use Box2D::b2Vec2;
use Box2D::b2Vec3;

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

1;    # End of Box2D
