use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new( 10, 11 );

isa_ok( $vec, "Box2D::b2Vec2" );

is( $vec->x, 10, "Get x" );
is( $vec->y, 11, "Get y" );

$vec->x(3);
$vec->y(4);

is( $vec->x, 3, "Set x" );
is( $vec->y, 4, "Set y" );

$vec = Box2D::b2Vec2->new();

isa_ok( $vec, "Box2D::b2Vec2" );

$vec->Set( 5, 6 );

is( $vec->x, 5, "Set" );
is( $vec->y, 6, "Set" );

$vec->y(5);

cmp_ok( abs( $vec->Length() - 7.07106781005859 ), '<', 0.00000001, "Length" );

is( $vec->LengthSquared(), 50, "LengthSquared" );

cmp_ok( abs( $vec->Normalize() - 7.07106781005859 ),
    '<', 0.00000001, "Normalize" );

ok( $vec->IsValid(), "IsValid" );

$vec->Set( -1e1000**1e1000, 2 );
ok( !$vec->IsValid(), "IsValid" );

$vec->Set( 4, -1e1000**1e1000 );
ok( !$vec->IsValid(), "IsValid" );

$vec->SetZero();

is( $vec->x, 0, "SetZero" );
is( $vec->y, 0, "SetZero" );

$vec += Box2D::b2Vec2->new(2, -4);
is( $vec->x, 2, "a += b" );
is( $vec->y, -4, "a += b" );

$vec *= 2.5;
is( $vec->x, 5, "a *= b" );
is( $vec->y, -10, "a *= b" );

$vec -= Box2D::b2Vec2->new(3, -9);
is( $vec->x, 2, "a -= b" );
is( $vec->y, -1, "a -= b" );

{
	my $c = -$vec;
	is( $c->x, -2, "-a" );
	is( $c->y, 1, "-a" );
}

{
	# Get the skew vector such that dot(skew_vec, other) == cross(vec, other)
	my $skew = $vec->Skew();
	my $other = Box2D::b2Vec2->new(3, -7);
	is( $skew . $other, $vec x $other, "Skew()" );
}

done_testing;
