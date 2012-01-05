package Box2D::b2Mat22;

use warnings;
use strict;
use Box2D;

use overload
	'+'      => '_add',
	fallback => 1,
;

sub _add {
	my ( $self, $other ) = @_;

	return Box2D::_mat22_add( $self, $other );
}

1;
