package Box2D;

use warnings;
use strict;


=head1 NAME

Box2D - 2D Physics Library

=cut

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Box2D', $VERSION);

1; # End of Box2D
