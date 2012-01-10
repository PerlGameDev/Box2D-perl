use strict;
use warnings;
use Box2D;
use Test::More;

my $edge = Box2D::b2EdgeShape->new();
ok( $edge, 'new' );
isa_ok( $edge, 'Box2D::b2EdgeShape' );


my $v0 = Box2D::b2Vec2->new( 0.0, 0.0 );
my $v1 = Box2D::b2Vec2->new( 1.0, 0.0 );
my $v2 = Box2D::b2Vec2->new( 1.0, 1.0 );
my $v3 = Box2D::b2Vec2->new( 1.0, 2.0 );

$edge->Set( $v1, $v2 );
pass('Set');

is( $edge->m_vertex1->x, $v1->x, 'm_vertex1 x' );
is( $edge->m_vertex1->y, $v1->y, 'm_vertex1 y' );
is( $edge->m_vertex2->x, $v2->x, 'm_vertex2 x' );
is( $edge->m_vertex2->y, $v2->y, 'm_vertex2 y' );
ok( ! $edge->m_hasVertex0, 'm_hasVertex0' );
ok( ! $edge->m_hasVertex3, 'm_hasVertex3' );

$edge->m_vertex0( $v0 );
$edge->m_hasVertex0(1);

$edge->m_vertex3( $v3 );
$edge->m_hasVertex3(1);

ok( $edge->m_hasVertex0, 'm_hasVertex0' );
is( $edge->m_vertex0->x, $v0->x, 'm_vertex0 x' );
is( $edge->m_vertex0->y, $v0->y, 'm_vertex0 y' );

ok( $edge->m_hasVertex3, 'm_hasVertex3' );
is( $edge->m_vertex3->x, $v3->x, 'm_vertex3 x' );
is( $edge->m_vertex3->y, $v3->y, 'm_vertex3 y' );

done_testing;
