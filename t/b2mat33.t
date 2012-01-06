use strict;
use warnings;
use Box2D;
use Test::More;

my ( $a11, $a21, $a31, $a12, $a22, $a32, $a13, $a23, $a33 ) = ( 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 );
my ( $b11, $b21, $b31, $b12, $b22, $b32, $b13, $b23, $b33 ) = ( 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0 );

my $exa = Box2D::b2Vec3->new( $a11, $a21, $a31 );
my $eya = Box2D::b2Vec3->new( $a12, $a22, $a32 );
my $eza = Box2D::b2Vec3->new( $a13, $a23, $a33 );
my $exb = Box2D::b2Vec3->new( $b11, $b21, $b31 );
my $eyb = Box2D::b2Vec3->new( $b12, $b22, $b32 );
my $ezb = Box2D::b2Vec3->new( $b13, $b23, $b33 );

my $matrix = Box2D::b2Mat33->new( $exa, $eya, $eza );

isa_ok( $matrix, "Box2D::b2Mat33" );

is( $matrix->ex->x, $a11, "new a11" );
is( $matrix->ey->x, $a12, "new a12" );
is( $matrix->ez->x, $a13, "new a13" );
is( $matrix->ex->y, $a21, "new a21" );
is( $matrix->ey->y, $a22, "new a22" );
is( $matrix->ez->y, $a23, "new a23" );
is( $matrix->ex->z, $a31, "new a31" );
is( $matrix->ey->z, $a32, "new a32" );
is( $matrix->ez->z, $a33, "new a33" );

$matrix->SetZero();

is( $matrix->ex->x, 0, "SetZero a11" );
is( $matrix->ey->x, 0, "SetZero a12" );
is( $matrix->ez->x, 0, "SetZero a13" );
is( $matrix->ex->y, 0, "SetZero a21" );
is( $matrix->ey->y, 0, "SetZero a22" );
is( $matrix->ez->y, 0, "SetZero a23" );
is( $matrix->ex->z, 0, "SetZero a31" );
is( $matrix->ey->z, 0, "SetZero a32" );
is( $matrix->ez->z, 0, "SetZero a33" );

$matrix->ex($exb);
$matrix->ey($eyb);
$matrix->ez($ezb);

is( $matrix->ex->x, $b11, "ex a11" );
is( $matrix->ey->x, $b12, "ey a12" );
is( $matrix->ez->x, $b13, "ez a13" );
is( $matrix->ex->y, $b21, "ex a21" );
is( $matrix->ey->y, $b22, "ey a22" );
is( $matrix->ez->y, $b23, "ez a23" );
is( $matrix->ex->z, $b31, "ex a31" );
is( $matrix->ey->z, $b32, "ey a32" );
is( $matrix->ez->z, $b33, "ez a33" );


TODO: {
	local $TODO = "I think this test is right. Is it possible that b2Math.c is wrong?";
	# Solve for x: A * x = b, where b is a column vector arg
	my $A = $matrix;
	my $b = Box2D::b2Mul($A, $exa);
	my $x = $A->Solve33( $b );
	cmp_ok( abs($x->x - $exa->x), "<=", 0.000001, "Solve33" );
	cmp_ok( abs($x->y - $exa->y), "<=", 0.000001, "Solve33" );
	cmp_ok( abs($x->z - $exa->z), "<=", 0.000001, "Solve33" );
}

{
	# Solve for x: A * x = b, where b is a column vector arg
	# Solve only the upper 2-by-2 matrix equation
	my $A = $matrix;
	my $ex = Box2D::b2Vec2->new(3, -5);
	my $b = Box2D::b2Mul22($A, $ex);
	my $x = $A->Solve22( $b );
	cmp_ok( abs($x->x - $ex->x), "<=", 0.000001, "Solve22" );
	cmp_ok( abs($x->y - $ex->y), "<=", 0.000001, "Solve22" );
}

# TODO: GetInverse22( M )

# TODO: GetInverse33( M )

done_testing;
