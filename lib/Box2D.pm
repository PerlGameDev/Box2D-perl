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
	%EXPORT_TAGS = ();
	@EXPORT_OK   = ();
}

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
