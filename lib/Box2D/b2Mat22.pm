package Box2D::b2Mat22;

use warnings;
use strict;
use Box2D;

use overload
	'+'   => '_add',
	'abs' => '_abs',
	fallback => 1,
;

sub _add {
	my ( $self, $other ) = @_;

	return Box2D::_mat22_add( $self, $other );
}

sub _abs {
	my ( $self ) = @_;
	
	return Box2D::b2Abs( $self );
}

1;
