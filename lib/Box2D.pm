package Box2D;

use warnings;
use strict;
our @ISA = qw(Exporter);

our $VERSION = '0.06';

require XSLoader;
XSLoader::load( 'Box2D', $VERSION );
require Exporter;

our %EXPORT_TAGS;
our @EXPORT_OK;
BEGIN {
	my @math_subs = qw(
		Box2D::b2IsValid
		Box2D::b2InvSqrt
		Box2D::b2Sqrt
		Box2D::b2Atan2
		Box2D::b2Vec2_zero
		Box2D::b2Dot
		Box2D::b2Cross
		Box2D::b2Mul
		Box2D::b2MulT
		Box2D::b2Distance
		Box2D::b2DistanceSquared
		Box2D::b2Mul22
		Box2D::b2Abs
		Box2D::b2Min
		Box2D::b2Max
		Box2D::b2Clamp
		Box2D::b2Swap
		Box2D::b2NextPowerOfTwo
		Box2D::b2IsPowerOfTwo
	);
	my @settings_subs      = qw();
	my @math_constants     = qw( Box2D::b2_version );
	my @settings_constants = qw( Box2D::b2Vec2_zero );
	%EXPORT_TAGS = (
		subs      => [ @math_subs, @settings_subs ],
		constants => [ @math_constants, @settings_constants ],
		math      => [ @math_subs, @math_constants ],
		settings  => [ @settings_subs, @settings_constants ],
	);
	@EXPORT_OK = ( @math_subs, @settings_subs, @math_constants, @settings_constants );
}
# All the rest of the constants have now been defined by the XS
$EXPORT_TAGS{all} = \@EXPORT_OK;

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
