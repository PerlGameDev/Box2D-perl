use strict;
use warnings;
use Box2D;
use Test::More;

cmp_ok( Box2D::b2Shape::e_circle   , ">=", 0, "enum Type constant" );
cmp_ok( Box2D::b2Shape::e_edge     , ">=", 0, "enum Type constant" );
cmp_ok( Box2D::b2Shape::e_polygon  , ">=", 0, "enum Type constant" );
cmp_ok( Box2D::b2Shape::e_chain    , ">=", 0, "enum Type constant" );
cmp_ok( Box2D::b2Shape::e_typeCount, ">=", 0, "enum Type constant" );

my $circle  = Box2D::b2CircleShape ->new();
my $edge    = Box2D::b2EdgeShape   ->new();
my $polygon = Box2D::b2PolygonShape->new();
my $chain   = Box2D::b2ChainShape  ->new();

is( $circle ->GetType, Box2D::b2Shape::e_circle , "GetType"    );
is( $edge   ->GetType, Box2D::b2Shape::e_edge   , "GetType"    );
is( $polygon->GetType, Box2D::b2Shape::e_polygon, "GetType"    );
is( $chain  ->GetType, Box2D::b2Shape::e_chain  , "GetType"    );
is( $circle ->m_type , Box2D::b2Shape::e_circle , "Get m_type" );
is( $edge   ->m_type , Box2D::b2Shape::e_edge   , "Get m_type" );
is( $polygon->m_type , Box2D::b2Shape::e_polygon, "Get m_type" );
is( $chain  ->m_type , Box2D::b2Shape::e_chain  , "Get m_type" );

my $v0 = Box2D::b2Vec2->new( 0, 0 );
my $v1 = Box2D::b2Vec2->new( 1, 0 );
my $v2 = Box2D::b2Vec2->new( 0, 1 );
my $r = 7;

$circle->m_radius( $r );
$edge->m_vertex1( $v1 );
$edge->m_vertex2( $v2 );
$polygon->Set( $v0, $v1, $v2 );
$chain->CreateChain( $v1, $v2, $v0 );

is    ( $circle ->m_radius ,     $r, "Get and Set m_radius" );
cmp_ok( $edge   ->m_radius , ">", 0, "Get m_radius" );
cmp_ok( $polygon->m_radius , ">", 0, "Get m_radius" );
cmp_ok( $chain  ->m_radius , ">", 0, "Get m_radius" );

is( $circle ->GetChildCount(), 1, "GetChildCount" ); # always 1
is( $edge   ->GetChildCount(), 1, "GetChildCount" ); # always 1
is( $polygon->GetChildCount(), 1, "GetChildCount" ); # always 1
is( $chain  ->GetChildCount(), 2, "GetChildCount" ); # m_vertices - 1

my $transform = Box2D::b2Transform->new();
$transform->p->SetZero();
$transform->q->SetIdentity();

ok(  $circle ->TestPoint( $transform, $v0                             ), "TestPoint" );
ok( !$circle ->TestPoint( $transform, Box2D::b2Vec2->new( $r + 1, 0 ) ), "TestPoint" );
ok( !$edge   ->TestPoint( $transform, $v1                             ), "TestPoint" ); # always false
ok(  $polygon->TestPoint( $transform, $v0                             ), "TestPoint" );
ok( !$polygon->TestPoint( $transform, Box2D::b2Vec2->new( 2, 0 )      ), "TestPoint" );
ok( !$chain  ->TestPoint( $transform, $v0                             ), "TestPoint" ); # always false

# RayCast

{
	my $aabb = Box2D::b2AABB->new();
	$circle->ComputeAABB( $aabb, $transform, 0 );
	is( $aabb->lowerBound->x, -$r, "ComputeAABB cirle lowerBound" );
	is( $aabb->lowerBound->y, -$r, "ComputeAABB cirle lowerBound" );
	is( $aabb->upperBound->x,  $r, "ComputeAABB circle upperBound" );
	is( $aabb->upperBound->y,  $r, "ComputeAABB circle upperBound" );
}
{
	my $aabb = Box2D::b2AABB->new();
	$edge->ComputeAABB( $aabb, $transform, 0 );
	cmp_ok( abs($aabb->lowerBound->x - (  - $edge->m_radius)), "<=", 1e-5, "ComputeAABB edge lowerBound" );
	cmp_ok( abs($aabb->lowerBound->y - (  - $edge->m_radius)), "<=", 1e-5, "ComputeAABB edge lowerBound" );
	cmp_ok( abs($aabb->upperBound->x - (1 + $edge->m_radius)), "<=", 1e-5, "ComputeAABB edge upperBound" );
	cmp_ok( abs($aabb->upperBound->y - (1 + $edge->m_radius)), "<=", 1e-5, "ComputeAABB edge upperBound" );
}
{
	my $aabb = Box2D::b2AABB->new();
	$polygon->ComputeAABB( $aabb, $transform, 0 );
	cmp_ok( abs($aabb->lowerBound->x - (  - Box2D::b2_polygonRadius)), "<=", 1e-5, "ComputeAABB polygon lowerBound" );
	cmp_ok( abs($aabb->lowerBound->y - (  - Box2D::b2_polygonRadius)), "<=", 1e-5, "ComputeAABB polygon lowerBound" );
	cmp_ok( abs($aabb->upperBound->x - (1 + Box2D::b2_polygonRadius)), "<=", 1e-5, "ComputeAABB polygon upperBound" );
	cmp_ok( abs($aabb->upperBound->y - (1 + Box2D::b2_polygonRadius)), "<=", 1e-5, "ComputeAABB polygon upperBound" );
}
{
	my $aabb = Box2D::b2AABB->new();
	$chain->ComputeAABB( $aabb, $transform, 0 );
	is( $aabb->lowerBound->x, 0, "ComputeAABB chain lowerBound" );
	is( $aabb->lowerBound->y, 0, "ComputeAABB chain lowerBound" );
	is( $aabb->upperBound->x, 1, "ComputeAABB chain upperBound" );
	is( $aabb->upperBound->y, 1, "ComputeAABB chain upperBound" );
}

{
	my $data = Box2D::b2MassData->new();
	$circle->ComputeMass( $data, 1 );
	cmp_ok( abs($data->mass - Box2D::b2_pi * $r ** 2), "<=", 1e-5, "b2MassData circle mass" );
	is( $data->center->x, 0, "b2MassData circle center" );
	is( $data->center->y, 0, "b2MassData circle center" );
	cmp_ok( abs($data->I - $data->mass * (0.5 * $r * $r)), "<=", 1e-4, "b2MassData circle I" );
}
{
	my $data = Box2D::b2MassData->new();
	$edge->ComputeMass( $data, 1 );
	is( $data->mass, 0, "b2MassData edge mass" );
	is( $data->center->x, 0.5, "b2MassData edge center" );
	is( $data->center->y, 0.5, "b2MassData edge center" );
	is( $data->I, 0, "b2MassData edge I" );
}
{
	my $data = Box2D::b2MassData->new();
	$polygon->ComputeMass( $data, 1 );
	cmp_ok( abs($data->mass - 0.5), '<=', 1e-5, "b2MassData polygon mass" );
	cmp_ok( abs($data->center->x - 1/3), "<=", 1e-5, "b2MassData polygon center" );
	cmp_ok( abs($data->center->y - 1/3), "<=", 1e-5, "b2MassData polygon center" );
	cmp_ok( abs($data->I - 1/6), "<=", 1e-5, "b2MassData polygon I" );
}
{
	my $data = Box2D::b2MassData->new();
	$chain->ComputeMass( $data, 1 );
	is( $data->mass, 0, "b2MassData chain mass" );
	is( $data->center->x, 0, "b2MassData chain center" );
	is( $data->center->y, 0, "b2MassData chain center" );
	is( $data->I, 0, "b2MassData chain I" );
}

$circle->m_type( 10 );
is( $circle->m_type, 10, "Set m_type" );

done_testing;
