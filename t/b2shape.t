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
}
{
	my $aabb = Box2D::b2AABB->new();
	$edge->ComputeAABB( $aabb, $transform, 0 );
}
{
	my $aabb = Box2D::b2AABB->new();
	$polygon->ComputeAABB( $aabb, $transform, 0 );
}
{
	my $aabb = Box2D::b2AABB->new();
	$chain->ComputeAABB( $aabb, $transform, 0 );
}

{
	my $mass = Box2D::b2MassData->new();
	$circle->ComputeMass( $mass, 1 );
}
{
	my $mass = Box2D::b2MassData->new();
	$edge->ComputeMass( $mass, 1 );
}
{
	my $mass = Box2D::b2MassData->new();
	$polygon->ComputeMass( $mass, 1 );
}
{
	my $mass = Box2D::b2MassData->new();
	$chain->ComputeMass( $mass, 1 );
}

$circle->m_type( 10 );
is( $circle->m_type, 10, "Set m_type" );

use Data::Dumper;
diag( Data::Dumper->Dump([\@Box2D::EXPORT_OK], [qq(...; \@Box2D::EXPORT_OK)]) );
diag( Data::Dumper->Dump([\%Box2D::EXPORT_TAGS], [qq(...; \%Box2D::EXPORT_TAGS)]) );

done_testing;
