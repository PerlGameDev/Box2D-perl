use strict;
use warnings;
use Box2D;
use Test::More;


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
