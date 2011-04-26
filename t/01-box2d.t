use strict;
use warnings;
use Box2D;
use Box2D::b2Vec2; 
use Test::More;

my $vec = new Box2D::b2Vec2( );

isa_ok( $vec, "Box2D::b2Vec2" );
done_testing;
