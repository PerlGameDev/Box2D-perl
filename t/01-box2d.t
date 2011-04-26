use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new( 10, 10 );

ok ( $vec );
done_testing;
