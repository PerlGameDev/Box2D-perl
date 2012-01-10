use strict;
use warnings;
use Box2D;
use Test::More;

my $v0 = Box2D::b2Vec2->new( 0.0, 0.0 );
my $v1 = Box2D::b2Vec2->new( 1.0, 0.0 );
my $v2 = Box2D::b2Vec2->new( 0.0, 1.0 );

my $chain = Box2D::b2ChainShape->new();

is( $chain->m_count, 0, "m_count" );

$chain->CreateChain( $v0, $v1, $v2 );
pass("CreateChain");

{
	my $edge = Box2D::b2EdgeShape->new();
	$chain->GetChildEdge( $edge, 0 );
	is( $edge->m_vertex1->x, $v0->x, "GetChildEdge m_vertex1" );
	is( $edge->m_vertex1->y, $v0->y, "GetChildEdge m_vertex1" );
	is( $edge->m_vertex2->x, $v1->x, "GetChildEdge m_vertex2" );
	is( $edge->m_vertex2->y, $v1->y, "GetChildEdge m_vertex2" );
}

is( $chain->m_count, 3, "m_count" );
$chain->m_count( 4 );
is( $chain->m_count, 4, "m_count set" );

ok( !$chain->m_hasPrevVertex, "m_hasPrevVertex" );
ok( !$chain->m_hasNextVertex, "m_hasNextVertex" );
$chain->m_hasPrevVertex( 1 );
$chain->m_hasNextVertex( 1 );
ok( $chain->m_hasPrevVertex, "m_hasPrevVertex set" );
ok( $chain->m_hasNextVertex, "m_hasNextVertex set" );
$chain->m_hasPrevVertex( 0 );
$chain->m_hasNextVertex( 0 );
ok( !$chain->m_hasPrevVertex, "m_hasPrevVertex set" );
ok( !$chain->m_hasNextVertex, "m_hasNextVertex set" );

{
	my $vertex = $chain->m_vertices( 0 );
	is( $vertex->x, $v0->x, "m_vertices 0" );
	is( $vertex->y, $v0->y, "m_vertices 0" );
}

{
	my $vertex = $chain->m_vertices( 1 );
	is( $vertex->x, $v1->x, "m_vertices 1" );
	is( $vertex->y, $v1->y, "m_vertices 1" );
}

{
	my $vertex = $chain->m_vertices( 2 );
	is( $vertex->x, $v2->x, "m_vertices 2" );
	is( $vertex->y, $v2->y, "m_vertices 2" );
}

{
	$chain->m_vertices( 0, $v1 );
	my $vertex = $chain->m_vertices( 0 );
	is( $vertex->x, $v1->x, "m_vertices set" );
	is( $vertex->y, $v1->y, "m_vertices set" );
}

{
	$chain->m_prevVertex( $v0 );
	$chain->m_nextVertex( $v2 );
	my $vertex = $chain->m_prevVertex;
	is( $vertex->x, $v0->x, "m_prevVertex set" );
	is( $vertex->y, $v0->y, "m_prevVertex set" );
	$vertex = $chain->m_nextVertex;
	is( $vertex->x, $v2->x, "m_nextVertex set" );
	is( $vertex->y, $v2->y, "m_nextVertex set" );
}

my $loop = Box2D::b2ChainShape->new();
$loop->CreateLoop( $v0, $v1, $v2 );
pass("CreateLoop");

is( $loop->m_count, 4, "m_count" );
ok( $loop->m_hasPrevVertex, "m_hasPrevVertex" );
ok( $loop->m_hasNextVertex, "m_hasNextVertex" );

{
	my $vertex = $loop->m_prevVertex;
	is( $vertex->x, $v2->x, "m_prevVertex" );
	is( $vertex->y, $v2->y, "m_prevVertex" );
	$vertex = $loop->m_nextVertex;
	is( $vertex->x, $v1->x, "m_nextVertex" );
	is( $vertex->y, $v1->y, "m_nextVertex" );
}

{
	my $vertex = $loop->m_vertices( 0 );
	is( $vertex->x, $v0->x, "m_vertices 0" );
	is( $vertex->y, $v0->y, "m_vertices 0" );
}

{
	my $vertex = $loop->m_vertices( 3 );
	is( $vertex->x, $v0->x, "m_vertices 3" );
	is( $vertex->y, $v0->y, "m_vertices 3" );
}

done_testing;
