use strict;
use warnings;
use Box2D;
use Box2D::b2Vec2;
use Test::More;

my $vec = Box2D::b2Vec2->new( 10, 0 );
pass();

done_testing;
