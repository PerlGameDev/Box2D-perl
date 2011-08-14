use strict;
use warnings;
use Box2D;
use Test::More;

ok( Box2D::b2Math::b2IsValid(0.0), "b2IsValid" );

cmp_ok( abs( Box2D::b2Math::b2InvSqrt(4.0) - 0.5 ), "<=", 0.001, "b2InvSqrt" );

is( Box2D::b2Math::b2Abs(1.0),  1.0, "b2Abs" );
is( Box2D::b2Math::b2Abs(-1.0), 1.0, "b2Abs" );

my $a = Box2D::b2Vec2->new( 1, 2 );
my $b = Box2D::b2Vec2->new( 3, 4 );
my $m = Box2D::b2Mat22->new( 5, 6, 7, 8 );
my $s = 9;

{
    my $c = Box2D::b2Math::b2DotV2V2( $a, $b );
    is( $c, $a->x  * $b->x + $a->y * $b->y, "b2DotV2V2" );
}

{
    my $c = Box2D::b2Math::b2CrossV2V2( $a, $b );
    is( $c, $a->x * $b->y - $a->y * $b->x, "b2CrossV2V2" );
}

{
    my $c = Box2D::b2Math::b2CrossV2S( $a, $s );
    is( $c->x, $s * $a->y,  "b2CrossV2S" );
    is( $c->y, -$s * $a->x, "b2CrossV2S" );
}

{
    my $c = Box2D::b2Math::b2CrossSV2( $s, $a );
    is( $c->x, -$s * $a->y, "b2CrossSV2" );
    is( $c->y, $s * $a->x,  "b2CrossSV2" );
}

{
    my $c = Box2D::b2Math::b2MulM22V2( $m, $a );
    is( $c->x, $m->col1->x * $a->x + $m->col2->x * $a->y, "b2MulM22V2" );
    is( $c->y, $m->col1->y * $a->x + $m->col2->y * $a->y, "b2MulM22V2" );
}

{
    my $c = Box2D::b2Math::b2MulTM22V2( $m, $a );
    is( $c->x, Box2D::b2Math::b2DotV2V2( $a, $m->col1 ), "b2MulTM22V2" );
    is( $c->y, Box2D::b2Math::b2DotV2V2( $a, $m->col2 ), "b2MulTM22V2" );
}

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

my ( $a11, $a12, $a21, $a22 ) = ( 1.0, 2.0, 3.0, 4.0 );
my $matrix = Box2D::b2Mat22->new( $a11, $a12, $a21, $a22 );
ok( $matrix );
isa_ok( $matrix, "Box2D::b2Mat22" );
is( $matrix->col1->x, $a11 );
is( $matrix->col2->x, $a12 );
is( $matrix->col1->y, $a21 );
is( $matrix->col2->y, $a22 );

my ( $b11, $b12, $b21, $b22 ) = ( 1.0, 2.0, 3.0, 4.0 );
$matrix->Set( Box2D::b2Vec2->new($b11, $b21), Box2D::b2Vec2->new($b12, $b22) );
is( $matrix->col1->x, $b11, "Set a11" );
is( $matrix->col2->x, $b12, "Set a12" );
is( $matrix->col1->y, $b21, "Set a21" );
is( $matrix->col2->y, $b22, "Set a22" );

$matrix->SetIdentity();
is( $matrix->col1->x, 1, "SetIdentity a11" );
is( $matrix->col2->x, 0, "SetIdentity a12" );
is( $matrix->col1->y, 0, "SetIdentity a21" );
is( $matrix->col2->y, 1, "SetIdentity a22" );

my $col1 = Box2D::b2Vec2->new( $b11, $b21 );
my $col2 = Box2D::b2Vec2->new( $b12, $b22 );
$matrix->Set( $col2, $col2 );
$matrix->SetZero();
is( $matrix->col1->x, 0, "SetZero a11" );
is( $matrix->col2->x, 0, "SetZero a12" );
is( $matrix->col1->y, 0, "SetZero a21" );
is( $matrix->col2->y, 0, "SetZero a22" );

my ( $x, $y, $angle ) = ( 7.0, 9.0, 1.0 );
my $position = Box2D::b2Vec2->new( $x, $y );
my $R = Box2D::b2Mat22->new();
$R->SetAngle($angle);
my $transform = Box2D::b2Transform->new( $position, $R );
ok( $transform );
isa_ok( $transform, "Box2D::b2Transform" );

is( $transform->position->x, $x );
is( $transform->position->y, $y );
is( $transform->GetAngle(), $angle );

done_testing;
