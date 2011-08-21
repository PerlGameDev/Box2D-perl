use strict;
use warnings;
use Box2D;
use Test::More;

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
