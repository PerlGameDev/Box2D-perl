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

is( $vec->Length(), 7.07106781005859 );

is( $vec->LengthSquared(), 50);

is( $vec->Normalize(), 7.07106781005859 );

ok ( ! defined $vec->SetZero()  );

is( $vec->x, 0 );
is( $vec->y, 0 );

is( $vec->IsValid(), '1' );



done_testing;
