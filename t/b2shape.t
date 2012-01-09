use strict;
use warnings;
use Box2D;
use Test::More;

cmp_ok( Box2D::b2Shape::e_circle   , ">=", 0, "enum Type constant");
cmp_ok( Box2D::b2Shape::e_edge     , ">=", 0, "enum Type constant");
cmp_ok( Box2D::b2Shape::e_polygon  , ">=", 0, "enum Type constant");
cmp_ok( Box2D::b2Shape::e_chain    , ">=", 0, "enum Type constant");
cmp_ok( Box2D::b2Shape::e_typeCount, ">=", 0, "enum Type constant");

my $circle = Box2D::b2CircleShape->new();
my $edge = Box2D::b2EdgeShape->new();
my $polygon = Box2D::b2PolygonShape->new();
my $chain = Box2D::b2ChainShape->new();

isa_ok( $circle , "Box2D::b2Shape" );
isa_ok( $edge   , "Box2D::b2Shape" );
isa_ok( $polygon, "Box2D::b2Shape" );
isa_ok( $chain  , "Box2D::b2Shape" );

is( $circle ->m_type, Box2D::b2Shape::e_circle , "Get m_type" );
is( $edge   ->m_type, Box2D::b2Shape::e_edge   , "Get m_type" );
is( $polygon->m_type, Box2D::b2Shape::e_polygon, "Get m_type" );
is( $chain  ->m_type, Box2D::b2Shape::e_chain  , "Get m_type" );

done_testing;
