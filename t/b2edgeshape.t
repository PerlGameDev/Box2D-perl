use strict;
use warnings;
use Box2D;
use Test::More;

my $edge = Box2D::b2EdgeShape->new();
ok( $edge, 'new' );
isa_ok( $edge, 'Box2D::b2EdgeShape' );

$edge->Set(
    Box2D::b2Vec2->new( 0.0, 0.0 ),
    Box2D::b2Vec2->new( 1.0, 0.0 ),
);
pass('Set');

done_testing;
