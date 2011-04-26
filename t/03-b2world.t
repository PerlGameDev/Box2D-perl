use strict;
use warnings;
use Box2D;
use Test::More;

my $gravity = Box2D::b2Vec2->new(0,-10);
my $world = Box2D::b2World->new($gravity, 1);
isa_ok( $world, "Box2D::b2World");

done_testing;
