use strict;
use warnings;
use Box2D;
use Test::More;

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

done_testing;
