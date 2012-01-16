use strict;
use warnings;
use Box2D;
use Test::More;

my $fixtureDef = Box2D::b2FixtureDef->new();
isa_ok( $fixtureDef, "Box2D::b2FixtureDef" );

cmp_ok( abs($fixtureDef->friction - 0.2), "<=", 1e-5, "initial friction" );
is( $fixtureDef->restitution, 0, "initial restitution" );
is( $fixtureDef->density    , 0, "initial density" );
ok( !$fixtureDef->isSensor, "initial isSensor" );

my $shape = Box2D::b2PolygonShape->new();
$fixtureDef->shape($shape);
is( $fixtureDef->shape->GetType, $shape->GetType, "shape" );
is( $fixtureDef->shape->m_radius, $shape->m_radius, "shape" );

{
	my $string = 'something';
	$fixtureDef->userData($string);
	is( $fixtureDef->userData, $string, "userData with string" );
}
{
	my $ref = \2;
	$fixtureDef->userData($ref);
	isa_ok( $fixtureDef->userData, 'SCALAR', "userData with ref" );
	is( ${$fixtureDef->userData}, $$ref, "userData with ref" );
	is( $fixtureDef->userData, $ref, "userData with ref" );
}

my $friction = 0.6;
$fixtureDef->friction($friction);
cmp_ok( abs($fixtureDef->friction - $friction), "<=", 1e-5, "set friction" );

my $restitution = 0.7;
$fixtureDef->restitution($restitution);
cmp_ok( abs($fixtureDef->restitution - $restitution), "<=", 1e-5, "set restitution" );

my $density = 0.8;
$fixtureDef->density($density);
cmp_ok( abs($fixtureDef->density - $density), "<=", 1e-5, "set density" );

$fixtureDef->isSensor(1);
ok( $fixtureDef->isSensor, "set isSensor" );
$fixtureDef->isSensor(0);
ok( !$fixtureDef->isSensor, "set isSensor" );

isa_ok( $fixtureDef->filter, "Box2D::b2Filter" );

done_testing;
