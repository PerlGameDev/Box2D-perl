use strict;
use warnings;
use Box2D;
use Test::More;

my $v0 = Box2D::b2Vec2->new( 0.0, 0.0 );
my $v1 = Box2D::b2Vec2->new( 1.0, 0.0 );
my $v2 = Box2D::b2Vec2->new( 0.0, 1.0 );

my $poly = Box2D::b2PolygonShape->new();

is( $poly->GetVertexCount, 0, "GetVertexCount" );
is( $poly->m_vertexCount, 0, "m_vertexCount" );
{
	my $cen = $poly->m_centroid;
	is( $cen->x, 0, "m_centroid" );
	is( $cen->y, 0, "m_centroid" );
}

$poly->Set( $v0, $v1, $v2 );
pass("Set");

is( $poly->GetVertexCount, 3, "GetVertexCount" );
is( $poly->m_vertexCount, 3, "m_vertexCount" );
$poly->m_vertexCount( 4 );
is( $poly->GetVertexCount, 4, "GetVertexCount" );
is( $poly->m_vertexCount, 4, "m_vertexCount" );
{
	my $cen = $poly->m_centroid;
	cmp_ok( abs($cen->x - 1/3), "<=", 1e-5, "m_centroid" );
	cmp_ok( abs($cen->y - 1/3), "<=", 1e-5, "m_centroid" );
	$poly->m_centroid( $v2 );
	$cen = $poly->m_centroid;
	is( $cen->x, $v2->x, "m_centroid" );
	is( $cen->y, $v2->y, "m_centroid" );
}

{
	my $vertex = $poly->GetVertex( 0 );
	is( $vertex->x, $v0->x, "GetVertex 0" );
	is( $vertex->y, $v0->y, "GetVertex 0" );
	$vertex = $poly->m_vertices( 0 );
	is( $vertex->x, $v0->x, "m_vertices 0" );
	is( $vertex->y, $v0->y, "m_vertices 0" );
	$vertex = $poly->m_normals( 0 );
	is( $vertex->x, 0, "m_normals 0" );
	is( $vertex->y, -1, "m_normals 0" );
}

{
	my $vertex = $poly->GetVertex( 1 );
	is( $vertex->x, $v1->x, "GetVertex 1" );
	is( $vertex->y, $v1->y, "GetVertex 1" );
	$vertex = $poly->m_vertices( 1 );
	is( $vertex->x, $v1->x, "m_vertices 1" );
	is( $vertex->y, $v1->y, "m_vertices 1" );
	$vertex = $poly->m_normals( 1 );
	cmp_ok( abs($vertex->x - sqrt(2)/2), "<=", 1e-5, "m_normals 1" );
	cmp_ok( abs($vertex->y - sqrt(2)/2), "<=", 1e-5, "m_normals 1" );
}

{
	my $vertex = $poly->GetVertex( 2 );
	is( $vertex->x, $v2->x, "GetVertex 2" );
	is( $vertex->y, $v2->y, "GetVertex 2" );
	$vertex = $poly->m_vertices( 2 );
	is( $vertex->x, $v2->x, "m_vertices 2" );
	is( $vertex->y, $v2->y, "m_vertices 2" );
	$vertex = $poly->m_normals( 2 );
	is( $vertex->x, -1, "m_normals 2" );
	cmp_ok( $vertex->y, '<=', 1e-5, "m_normals 2" );
}

{
	$poly->m_vertices( 0, $v2 );
	my $vertex = $poly->GetVertex( 0 );
	is( $vertex->x, $v2->x, "m_vertices set" );
	is( $vertex->y, $v2->y, "m_vertices set" );
	$vertex = $poly->m_vertices( 0 );
	is( $vertex->x, $v2->x, "m_vertices set" );
	is( $vertex->y, $v2->y, "m_vertices set" );
}

{
	$poly->m_normals( 1, $v0 );
	my $vertex = $poly->m_normals( 1 );
	is( $vertex->x, $v0->x, "m_normals set" );
	is( $vertex->y, $v0->y, "m_normals set" );
}

my ( $w, $h ) = ( 10.0, 12.0 );
my $rect = Box2D::b2PolygonShape->new();
$rect->SetAsBox( $w / 2.0, $h / 2.0 );

is( $rect->GetVertexCount, 4, "GetVertexCount" );

foreach ( 0 .. 3 ) {
    my $vertex = $rect->GetVertex($_);
    is( abs( $vertex->x ), $w / 2, "SetAsBox(2) GetVertex $_" );
    is( abs( $vertex->y ), $h / 2, "SetAsBox(2) GetVertex $_" );
}

my ( $x, $y, $angle ) = ( 14.0, 16.0, 0.0 );
my $rect2 = Box2D::b2PolygonShape->new();
$rect2->SetAsBox( $w, $h, Box2D::b2Vec2->new( $x, $y), $angle );

is( $rect2->GetVertexCount, 4, "SetAsBox(4) GetVertexCount" );
is( $rect2->m_centroid->x, $x, "SetAsBox(4) m_centroid" );
is( $rect2->m_centroid->y, $y, "SetAsBox(4) m_centroid" );

foreach ( 0 .. 3 ) {
    my $vertex = $rect2->GetVertex($_);
    is( abs( $vertex->x - $x ), $w, "SetAsBox(4) GetVertex $_" );
    is( abs( $vertex->y - $y ), $h, "SetAsBox(4) GetVertex $_" );
}

done_testing;
