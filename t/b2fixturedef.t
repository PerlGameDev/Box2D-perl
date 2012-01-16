use strict;
use warnings;
use Box2D;
use Test::More;

my $fixture_def = Box2D::b2FixtureDef->new();
isa_ok( $fixture_def, "Box2D::b2FixtureDef" );

cmp_ok( abs($fixture_def->friction - 0.2), "<=", 1e-5, "initial friction" );
is( $fixture_def->restitution, 0, "initial restitution" );
is( $fixture_def->density    , 0, "initial density" );
ok( !$fixture_def->isSensor, "initial isSensor" );

my $shape = Box2D::b2PolygonShape->new();
$fixture_def->shape($shape);
is( $fixture_def->shape->GetType, $shape->GetType, "shape" );
is( $fixture_def->shape->m_radius, $shape->m_radius, "shape" );

{
	my $data = 'something';
	my $data_copy = $data;
	$fixture_def->userData($data);
	is( $fixture_def->userData, $data_copy, "userData with string" );
	$data = \2;
	is( $fixture_def->userData, $data_copy, "userData with string" );
	$fixture_def->userData($data);
	isa_ok( $fixture_def->userData, ref $data, "userData with ref" );
	is( ${$fixture_def->userData}, $$data, "userData with ref" );
	is( $fixture_def->userData, $data, "userData with ref" );
}

my $friction = 0.6;
$fixture_def->friction($friction);
cmp_ok( abs($fixture_def->friction - $friction), "<=", 1e-5, "set friction" );

my $restitution = 0.7;
$fixture_def->restitution($restitution);
cmp_ok( abs($fixture_def->restitution - $restitution), "<=", 1e-5, "set restitution" );

my $density = 0.8;
$fixture_def->density($density);
cmp_ok( abs($fixture_def->density - $density), "<=", 1e-5, "set density" );

$fixture_def->isSensor(1);
ok( $fixture_def->isSensor, "set isSensor" );
$fixture_def->isSensor(0);
ok( !$fixture_def->isSensor, "set isSensor" );

isa_ok( $fixture_def->filter, "Box2D::b2Filter" );

done_testing;
