use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec3->new( 10, 11, 12 );

isa_ok( $vec, "Box2D::b2Vec3" );

is( $vec->x, 10, "Get x" );
is( $vec->y, 11, "Get y" );
is( $vec->z, 12, "Get z" );

$vec->x(3);
$vec->y(4);
$vec->z(5);

is( $vec->x, 3, "Set x" );
is( $vec->y, 4, "Set y" );
is( $vec->z, 5, "Set z" );

$vec = Box2D::b2Vec3->new();

isa_ok( $vec, "Box2D::b2Vec3" );

$vec->Set( 6, 7, 8 );

is( $vec->x, 6, "Set" );
is( $vec->y, 7, "Set" );
is( $vec->z, 8, "Set" );

$vec->SetZero();

is( $vec->x, 0, "SetZero" );
is( $vec->y, 0, "SetZero" );
is( $vec->z, 0, "SetZero" );

$vec += Box2D::b2Vec3->new(2, -4, 6);
is( $vec->x, 2, "a += b" );
is( $vec->y, -4, "a += b" );
is( $vec->z, 6, "a += b" );

$vec *= 2.5;
is( $vec->x, 5, "a *= b" );
is( $vec->y, -10, "a *= b" );
is( $vec->z, 15, "a *= b" );

$vec -= Box2D::b2Vec3->new(3, -9, 4);
is( $vec->x, 2, "a -= b" );
is( $vec->y, -1, "a -= b" );
is( $vec->z, 11, "a -= b" );

{
	my $c = -$vec;
	is( $c->x, -2, "-a" );
	is( $c->y, 1, "-a" );
	is( $c->z, -11, "-a" );
}

done_testing;
