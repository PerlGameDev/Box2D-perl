use strict;
use warnings;
use Box2D;
use Test::More;

my $rot = Box2D::b2Rot->new( 0 );

isa_ok( $rot, "Box2D::b2Rot" );

is( $rot->s, 0, "Get s" );
is( $rot->c, 1, "Get c" );
is( $rot->GetAngle(), 0, "GetAngle" );

$rot->Set( Box2D::b2_pi / 2 );

cmp_ok( abs($rot->s - 1), "<=", 0.0000001, "Set" );
cmp_ok( abs($rot->c - 0), "<=", 0.0000001, "Set" );

$rot->SetIdentity();

is( $rot->s, 0, "Get s" );
is( $rot->c, 1, "Get c" );

$rot = Box2D::b2Rot->new();

isa_ok( $rot, "Box2D::b2Rot" );

$rot->s(1);
$rot->c(0);

is( $rot->s, 1, "Set s" );
is( $rot->c, 0, "Set c" );
cmp_ok( abs($rot->GetAngle() - Box2D::b2_pi / 2), "<=", 0.0000001, "GetAngle" );

$rot->Set( 1.5 );

cmp_ok( abs($rot->s - sin 1.5), "<=", 0.0000001, "Set" );
cmp_ok( abs($rot->c - cos 1.5), "<=", 0.0000001, "Set" );

{
	my $x = $rot->GetXAxis();
	is( $x->x, $rot->c, "GetXAxis" );
	is( $x->y, $rot->s, "GetXAxis" );
}

{
	my $y = $rot->GetYAxis();
	is( $y->x, -$rot->s, "GetYAxis" );
	is( $y->y, $rot->c, "GetYAxis" );
}

done_testing;
