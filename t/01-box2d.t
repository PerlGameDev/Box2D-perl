use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new( );

isa_ok( $vec, "Box2D::b2Vec2" );
done_testing;
