use strict;
use warnings;
use Box2D;
use Test::More;

my $gravity = Box2D::b2Vec2->new( 0, -10 );
my $world = Box2D::b2World->new( $gravity );

my $body_def = Box2D::b2BodyDef->new;
my $body = $world->CreateBody( $body_def );

my $body2 = $world->CreateBody( Box2D::b2BodyDef->new );

my $fixture2 = $body->CreateFixture( Box2D::b2CircleShape->new, 1 );

my $fixture_def = Box2D::b2FixtureDef->new;
my ($w, $h) = (4, 6);
my $shape = Box2D::b2PolygonShape->new;
$shape->SetAsBox( $w/2, $h/2 );
$fixture_def->shape( $shape );
$fixture_def->isSensor(1);
$fixture_def->filter->groupIndex( 18 );
$fixture_def->userData( "something" );
$fixture_def->density( 10 );
$fixture_def->friction( 11 );
$fixture_def->restitution( 12 );
my $fixture = $body->CreateFixture( $fixture_def );

isa_ok( $fixture, "Box2D::b2Fixture" );

is( $fixture->GetType(), Box2D::b2Shape::e_polygon, "GetType" );

isa_ok( $fixture->GetShape(), "Box2D::b2PolygonShape", "GetShape polygon" );
is( $fixture->GetShape()->GetType, Box2D::b2Shape::e_polygon, "GetShape polygon" );

{
	my $circle = Box2D::b2CircleShape->new;
	$circle->m_radius( 4 );
	my $circle_fixture = $body2->CreateFixture( $circle, 1 );
	isa_ok( $circle_fixture->GetShape(), "Box2D::b2CircleShape", "GetShape circle" );
	is( $circle_fixture->GetShape()->m_radius, $circle->m_radius, "GetShape circle" );
}
{
	my $edge = Box2D::b2EdgeShape->new;
	my $v1 = Box2D::b2Vec2->new( 1, 2 );
	my $v2 = Box2D::b2Vec2->new( 3, 4 );
	$edge->m_vertex1( $v1 );
	$edge->m_vertex2( $v2 );
	my $edge_fixture = $body2->CreateFixture( $edge, 0 );
	isa_ok( $edge_fixture->GetShape(), "Box2D::b2EdgeShape", "GetShape edge" );
	is( $edge_fixture->GetShape()->m_vertex2->x, $v2->x, "GetShape edge" );
}
{
	my $chain = Box2D::b2ChainShape->new;
	my $v1 = Box2D::b2Vec2->new( 5, 6 );
	my $v2 = Box2D::b2Vec2->new( 7, 8 );
	$chain->CreateChain( $v1, $v2 );
	my $chain_fixture = $body2->CreateFixture( $chain, 0 );
	isa_ok( $chain_fixture->GetShape(), "Box2D::b2ChainShape", "GetShape chain" );
	is( $chain_fixture->GetShape()->GetType(), Box2D::b2Shape::e_chain, "GetShape chain" );
}

ok( $fixture->IsSensor(), "IsSensor" );
$fixture->SetSensor(0);
ok( !$fixture->IsSensor(), "SetSensor" );
$fixture->SetSensor(1);
ok( $fixture->IsSensor(), "SetSensor" );

is( $fixture->GetFilterData()->groupIndex, $fixture_def->filter->groupIndex, "GetFilterData" );
{
	my $filter = Box2D::b2Filter->new;
	$filter->maskBits( 2 );
	$fixture->SetFilterData( $filter );
	is( $fixture->GetFilterData()->maskBits, $filter->maskBits, "SetFilterData" );
}

$body->SetBullet(1);
isa_ok( $fixture->GetBody(), "Box2D::b2Body", "GetBody" );
is( $fixture->GetBody()->IsBullet(), 1, "GetBody" );

isa_ok( $fixture->GetNext(), "Box2D::b2Fixture", "GetNext" );
is( $fixture->GetNext()->GetType(), $fixture2->GetType(), "GetNext" );

is( $fixture->GetUserData(), $fixture_def->userData, "GetUserData" );
{
	my $data = "somethingelse";
	my $data_copy = $data;
	$fixture->SetUserData( $data );
	is( $fixture->GetUserData(), $data_copy, "SetUserData with string" );
	$data = [3];
	is( $fixture->GetUserData(), $data_copy, "SetUserData with string" );
	$fixture->SetUserData( $data );
	isa_ok( $fixture->GetUserData(), ref $data, "SetUserData with ref" );
	is( $fixture->GetUserData()->[0], $data->[0], "SetUserData with ref" );
	is( $fixture->GetUserData(), $data, "SetUserData with ref" );
}

#TestPoint

#RayCast

{
	my $expect_mass_data = Box2D::b2MassData->new;
	$shape->ComputeMass( $expect_mass_data, $fixture_def->density );
	my $mass_data = Box2D::b2MassData->new;
	$fixture->GetMassData( $mass_data );
	is( $mass_data->mass, $expect_mass_data->mass, "GetMassData" );
}

is( $fixture->GetDensity(), $fixture_def->density, "GetDensity" );
{
	my $density = 44;
	$fixture->SetDensity( $density );
	is( $fixture->GetDensity(), $density, "SetDensity" );
}

is( $fixture->GetFriction(), $fixture_def->friction, "GetFriction" );
{
	my $friction = 44;
	$fixture->SetFriction( $friction );
	is( $fixture->GetFriction(), $friction, "SetFriction" );
}

is( $fixture->GetRestitution(), $fixture_def->restitution, "GetRestitution" );
{
	my $restitution = 44;
	$fixture->SetRestitution( $restitution );
	is( $fixture->GetRestitution(), $restitution, "SetRestitution" );
}

#GetAABB

#Dump

done_testing;
