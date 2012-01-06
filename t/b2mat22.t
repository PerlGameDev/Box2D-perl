use strict;
use warnings;
use Box2D;
use Test::More;

my ( $a11, $a12, $a21, $a22 ) = ( 1.0, 2.0, 3.0, 4.0 );
my ( $b11, $b12, $b21, $b22 ) = ( 5.0, 6.0, 7.0, 8.0 );

my $exa = Box2D::b2Vec2->new( $a11, $a21 );
my $eya = Box2D::b2Vec2->new( $a12, $a22 );
my $exb = Box2D::b2Vec2->new( $b11, $b21 );
my $eyb = Box2D::b2Vec2->new( $b12, $b22 );

my $matrix = Box2D::b2Mat22->new( $a11, $a12, $a21, $a22 );

isa_ok( $matrix, "Box2D::b2Mat22" );

is( $matrix->ex->x, $a11, "Get ex->x" );
is( $matrix->ey->x, $a12, "Get ey->x" );
is( $matrix->ex->y, $a21, "Get ex->y" );
is( $matrix->ey->y, $a22, "Get ey->y" );

$matrix->Set( $exb, $eyb );

is( $matrix->ex->x, $b11, "Set a11" );
is( $matrix->ey->x, $b12, "Set a12" );
is( $matrix->ex->y, $b21, "Set a21" );
is( $matrix->ey->y, $b22, "Set a22" );

$matrix->SetIdentity();

is( $matrix->ex->x, 1, "SetIdentity a11" );
is( $matrix->ey->x, 0, "SetIdentity a12" );
is( $matrix->ex->y, 0, "SetIdentity a21" );
is( $matrix->ey->y, 1, "SetIdentity a22" );

$matrix->Set( $exb, $eyb );

$matrix->SetZero();

is( $matrix->ex->x, 0, "SetZero a11" );
is( $matrix->ey->x, 0, "SetZero a12" );
is( $matrix->ex->y, 0, "SetZero a21" );
is( $matrix->ey->y, 0, "SetZero a22" );

$matrix->ex($exb);
$matrix->ey($eyb);

is( $matrix->ex->x, $b11, "ex x" );
is( $matrix->ey->x, $b12, "ey x" );
is( $matrix->ex->y, $b21, "ex y" );
is( $matrix->ey->y, $b22, "ey y" );

$matrix = Box2D::b2Mat22->new( $eyb, $exa );

isa_ok( $matrix, "Box2D::b2Mat22" );

is( $matrix->ex->x, $b12, "new v2, v2 a11" );
is( $matrix->ey->x, $a11, "new v2, v2 a12" );
is( $matrix->ex->y, $b22, "new v2, v2 a21" );
is( $matrix->ey->y, $a21, "new v2, v2 a22" );

# TODO: GetInverse()

{
	# Solve for x: A * x = b, where b is a column vector arg
	my $A = $matrix;
	my $b = Box2D::b2Mul($A, $exa);
	my $x = $A->Solve( $b );
	cmp_ok( abs($x->x - $exa->x), "<=", 0.000001, "Solve" );
	cmp_ok( abs($x->y - $exa->y), "<=", 0.000001, "Solve" );
}

done_testing;
