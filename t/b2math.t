use strict;
use warnings;
use Box2D;
use Test::More;

ok( Box2D::b2IsValid(0.0),  "b2IsValid" );
ok( Box2D::b2IsValid(1.0),  "b2IsValid" );
ok( Box2D::b2IsValid(-1.0), "b2IsValid" );
ok( !Box2D::b2IsValid(1e1000**1e1000), "!b2IsValid" );
ok( !Box2D::b2IsValid(-1e1000**1e1000), "!b2IsValid" );
my $nan = "NaN";
SKIP: {
	skip "No NaN support", 1 unless $nan != $nan;
	ok( !Box2D::b2IsValid($nan), "!b2IsValid" );
}

cmp_ok( abs( Box2D::b2InvSqrt(4.0) - 0.5 ), "<=", 0.001, "b2InvSqrt" );

cmp_ok( abs( Box2D::b2Sqrt(94) - sqrt(94) ), "<=", 0.001, "b2Sqrt" );
cmp_ok( abs( Box2D::b2Sqrt(7.3) - sqrt(7.3) ), "<=", 0.001, "b2Sqrt" );

cmp_ok( abs( Box2D::b2Atan2(35, 5.4) - atan2(35, 5.4) ), "<=", 0.001, "b2Atan2" );

my $a = Box2D::b2Vec2->new( 1, 2 );
my $b = Box2D::b2Vec2->new( 3, 4 );
my $m = Box2D::b2Mat22->new( 5, 6, 7, 8 );
my $s = 9;
my $t = 10;
my $q = Box2D::b2Vec3->new( 11, 12, 13 );
my $r = Box2D::b2Vec3->new( 14, 15, 16 );

{
    my $c = Box2D::b2Dot( $a, $b );
    is( $c, $a->x * $b->x + $a->y * $b->y, "b2Dot" );
}

{
    my $c = $a . $b;
    is( $c, $a->x * $b->x + $a->y * $b->y, "a . b" );
}

{
    my $c = Box2D::b2Cross( $a, $b );
    is( $c, $a->x * $b->y - $a->y * $b->x, "b2Cross a, b" );
}

{
    my $c = Box2D::b2Cross( $a, $s );
    is( $c->x, $s * $a->y,  "b2Cross a, s" );
    is( $c->y, -$s * $a->x, "b2Cross a, s" );
}

{
    my $c = Box2D::b2Cross( $s, $a );
    is( $c->x, -$s * $a->y, "b2Cross s, a" );
    is( $c->y, $s * $a->x,  "b2Cross s, a" );
}

{
    my $c = $a x $b;
    is( $c, $a->x * $b->y - $a->y * $b->x, "a x b" );
}

{
    my $c = $a x $s;
    is( $c->x, $s * $a->y,  "a x s" );
    is( $c->y, -$s * $a->x, "a x s" );
}

{
    my $c = $s x $a;
    is( $c->x, -$s * $a->y, "s x a" );
    is( $c->y, $s * $a->x,  "s x a" );
}

{
    my $c = Box2D::b2Mul( $m, $a );
    is( $c->x, $m->ex->x * $a->x + $m->ey->x * $a->y, "b2Mul" );
    is( $c->y, $m->ex->y * $a->x + $m->ey->y * $a->y, "b2Mul" );
}

{
    my $c = Box2D::b2MulT( $m, $a );
    is( $c->x, Box2D::b2Dot( $a, $m->ex ), "b2MulT" );
    is( $c->y, Box2D::b2Dot( $a, $m->ey ), "b2MulT" );
}

{
    my $c = $a + $b;
    is( $c->x, $a->x + $b->x, "a + b" );
    is( $c->y, $a->y + $b->y, "a + b" );
}

{
    my $c = $a - $b;
    is( $c->x, $a->x - $b->x, "a - b" );
    is( $c->y, $a->y - $b->y, "a - b" );
}

{
    my $c = $s * $a;
    is( $c->x, $s * $a->x, "s * a" );
    is( $c->y, $s * $a->y, "s * a" );
}

{
    ok( !($a == $b ), "!(a == b)" );
    ok( !($b == $a ), "!(b == a)" );
    ok( $a != $b, "a != b" );
    ok( $b != $a, "b != a" );
    ok( $a == $a, "a == a" );
    ok( $b == $b, "a == a" );
    ok( !($a != $a), "!(a != a)" );
    ok( !($b != $b), "!(a != a)" );
	ok(Box2D::b2Vec2->new(33, 5.7) == Box2D::b2Vec2->new(33, 5.7), "a == a");
	ok(!(Box2D::b2Vec2->new(9.9, 95) != Box2D::b2Vec2->new(9.9, 95)), "!(a != a)");

    my $c = Box2D::b2Vec2->new( $a->x, $a->y );
    ok( $a == $c, "a == b" );
}

{
    my $c = Box2D::b2Distance( $a, $b );
    is( $c, ( $a - $b )->Length, "b2Distance" );
}

{
    my $c = Box2D::b2DistanceSquared( $a, $b );
    my $d = $a - $b;
    is( $c, Box2D::b2Dot( $d, $d ), "b2DistanceSquared" );
}

{
	my $c = $s * $r;
	is( $c->x, $s * $r->x, "v3 s * a" );
	is( $c->y, $s * $r->y, "v3 s * a" );
	is( $c->z, $s * $r->z, "v3 s * a" );
}

{
	my $c = $r + $q;
	is( $c->x, $r->x + $q->x, "v3 a * b" );
	is( $c->y, $r->y + $q->y, "v3 a * b" );
	is( $c->z, $r->z + $q->z, "v3 a * b" );
}

{
	my $c = $q - $r;
	is( $c->x, $q->x - $r->x, "v3 a - b" );
	is( $c->y, $q->y - $r->y, "v3 a - b" );
	is( $c->z, $q->z - $r->z, "v3 a - b" );
}

{
	my $c = Box2D::b2Dot($r, $q);
	is( $c, $r->x * $q->x + $r->y * $q->y + $r->z * $q->z, "v3 b2Dot" );
}

{
	my $c = $q . $r;
	is( $c, $r->x * $q->x + $r->y * $q->y + $r->z * $q->z, "v3 a . b" );
}

{
	my $c = Box2D::b2Cross($r, $q);
	is( $c->x, $r->y * $q->z - $r->z * $q->y, "v3 b2Cross" );
	is( $c->y, $r->z * $q->x - $r->x * $q->z, "v3 b2Cross" );
	is( $c->z, $r->x * $q->y - $r->y * $q->x, "v3 b2Cross" );
}

{
	my $c = $q x $r;
	is( $c->x, $q->y * $r->z - $q->z * $r->y, "v3 a x b" );
	is( $c->y, $q->z * $r->x - $q->x * $r->z, "v3 a x b" );
	is( $c->z, $q->x * $r->y - $q->y * $r->x, "v3 a x b" );
}

is( Box2D::b2Abs(1.0),  1.0, "b2Abs" );
is( Box2D::b2Abs(-1.0), 1.0, "b2Abs" );

{
	my $d = $a - $b;
	my $c = Box2D::b2Abs($d);
	is( $c->x, abs($d->x), "b2Abs" );
	is( $c->y, abs($d->y), "b2Abs" );
}

{
	my $d = $a - $b;
	my $c = abs($d);
	is( $c->x, abs($d->x), "abs" );
	is( $c->y, abs($d->y), "abs" );
}

is( Box2D::b2Min($s, $t), $s, "b2Min" );
is( Box2D::b2Min($t, $s), $s, "b2Min" );
is( Box2D::b2Max($s, $t), $t, "b2Max" );
is( Box2D::b2Max($t, $s), $t, "b2Max" );

{
	my $c = Box2D::b2Min($a, $b);
	is( $c->x, $a->x, "b2Min" );
	is( $c->y, $a->y, "b2Min" );
}

{
	my $c = Box2D::b2Min($b, $a);
	is( $c->x, $a->x, "b2Min" );
	is( $c->y, $a->y, "b2Min" );
}

{
	my $c = Box2D::b2Max($a, $b);
	is( $c->x, $b->x, "b2Max" );
	is( $c->y, $b->y, "b2Max" );
}

{
	my $c = Box2D::b2Max($b, $a);
	is( $c->x, $b->x, "b2Max" );
	is( $c->y, $b->y, "b2Max" );
}

{
	my $d = 1;
	my $low = 3;
	my $high = 4;
	my $c = Box2D::b2Clamp($d, $low, $high);
	is( $c, $low, "b2Clamp" );
}

{
	my $d = Box2D::b2Vec2->new(3, 6);
	my $low = Box2D::b2Vec2->new(-2, 4);
	my $high = Box2D::b2Vec2->new(8, 5);
	my $c = Box2D::b2Clamp($d, $low, $high);
	is( $c->x, $d->x, "b2Clamp" );
	is( $c->y, $high->y, "b2Clamp" );
}

TODO: {
	local $TODO = "dunno how to get the xsp to work";
	my $d = 123;
	my $e = \456;
	Box2D::b2Swap($d, $e);
	is( $$d, 456, "b2Swap" );
	is( $e, 123, "b2Swap" );
}

is( Box2D::b2NextPowerOfTwo(64), 128, "b2NextPowerOfTwo");

ok( Box2D::b2IsPowerOfTwo(8), "b2IsPowerOfTwo");
ok( !Box2D::b2IsPowerOfTwo(31), "b2IsPowerOfTwo");

done_testing;
