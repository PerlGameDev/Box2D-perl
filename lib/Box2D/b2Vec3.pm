package Box2D::b2Vec3;

use warnings;
use strict;
use Box2D;

use overload
	'+'      => '_add',
	'-'      => '_subtract',
	'*'      => '_multiply',
	'.'      => '_dot',
	'x'      => '_cross',
	'neg'    => sub { $_[0]->_negate() },
	fallback => 1,
;

sub _add {
	my ( $self, $other ) = @_;

	return Box2D::_vec3_add( $self, $other );
}

sub _subtract {
	my ( $self, $other, $swap ) = @_;

	if ($swap) {
		return Box2D::_vec3_subtract( $other, $self );
	}
	else {
		return Box2D::_vec3_subtract( $self, $other );
	}
}

sub _multiply {
	my ( $self, $other ) = @_;

	return Box2D::_vec3_multiply( $other, $self );
}

sub _dot {
	my ( $self, $other ) = @_;

	return Box2D::b2Dot( $self, $other );
}

sub _cross {
	my ( $self, $other, $swap ) = @_;

	return Box2D::b2Cross( $self, $other );
}

1;
