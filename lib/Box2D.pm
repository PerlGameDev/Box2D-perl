package Box2D;

use warnings;
use strict;
our @ISA = qw(Exporter);

=head1 NAME

Box2D - 2D Physics Library

=cut

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Box2D', $VERSION);
require Exporter;


1; # End of Box2D
