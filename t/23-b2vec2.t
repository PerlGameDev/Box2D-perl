use strict;
use warnings;
use Box2D;
use Test::More;

my $a = Box2D::b2Vec2->new( 1, 2 );
my $b = Box2D::b2Vec2->new( 3, 4 );
my $m = Box2D::b2Mat22->new( 5, 6, 7, 8 );
my $s = 9;

{
    my $c = $a + $b;
    is( $c->x, $a->x + $b->x, "b2Vec2 + b2Vec2" );
    is( $c->y, $a->y + $b->y, "b2Vec2 + b2Vec2" );
}

{
    my $c = $a - $b;
    is( $c->x, $a->x - $b->x, "b2Vec2 - b2Vec2" );
    is( $c->y, $a->y - $b->y, "b2Vec2 - b2Vec2" );
}

{
    my $c = $s * $a;
    is( $c->x, $s * $a->x, "scalar * b2Vec2" );
    is( $c->y, $s * $a->y, "scalar * b2Vec2" );
}

{
    ok( !($a == $b), "b2Vec2 == b2Vec2" );
    ok( !($b == $a), "b2Vec2 == b2Vec2" );
    ok( $a == $a,    "b2Vec2 == b2Vec2" );
    ok( $b == $b,    "b2Vec2 == b2Vec2" );

    my $c = Box2D::b2Vec2->new( $a->x, $a->y );
    ok( $a == $c, "b2Vec2 == b2Vec2" );
}

my $vec = Box2D::b2Vec2->new( 10, 10 );

ok ( $vec );

is( $vec->x, 10 );
is( $vec->y, 10 );

$vec->x(3);
$vec->y(4);

is( $vec->x, 3 );
is( $vec->y, 4 );

$vec->Set(5,5);

is( $vec->x, 5 );
is( $vec->y, 5 );

cmp_ok( abs($vec->Length() - 7.07106781005859), '<', 0.00000001 );

is( $vec->LengthSquared(), 50);

cmp_ok( abs($vec->Normalize() - 7.07106781005859), '<', 0.00000001 );

ok ( ! defined $vec->SetZero()  );

is( $vec->x, 0 );
is( $vec->y, 0 );

is( $vec->IsValid(), '1' );

done_testing;
