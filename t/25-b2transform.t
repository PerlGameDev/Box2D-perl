use strict;
use warnings;
use Box2D;
use Test::More;

my ( $x,  $y,  $angle )  = ( 7.0,  9.0,  1.0 );
my ( $x2, $y2, $angle2 ) = ( 11.0, 13.0, 2.0 );

my $position  = Box2D::b2Vec2->new( $x,  $y );
my $position2 = Box2D::b2Vec2->new( $x2, $y2 );

my $R  = Box2D::b2Rot->new( $angle );
my $R2 = Box2D::b2Rot->new( $angle2 );

my $transform = Box2D::b2Transform->new( $position, $R );

ok( $transform, "new" );

isa_ok( $transform, "Box2D::b2Transform" );

is( $transform->p->x, $x, "position->x" );
is( $transform->p->y, $y, "position->y" );

cmp_ok( abs( $transform->q->GetAngle() - $angle ), "<=", 0.00000001,
    "GetAngle" );

$transform->Set( $position2, $angle2 );

is( $transform->p->x, $x2, "Set position->x" );
is( $transform->p->y, $y2, "Set position->y" );

cmp_ok( abs( $transform->q->GetAngle() - $angle2 ),
    "<=", 0.00000001, "Set angle" );

$transform->SetIdentity();

is( $transform->p->x, 0, "SetIdentity p->x" );
is( $transform->p->y, 0, "SetIdentity p->y" );
is( $transform->q->s, 0, "SetIdentity q->s" );
is( $transform->q->c, 1, "SetIdentity q->c" );

$transform->p($position2);
is( $transform->p->x, $x2, "Set position x" );
is( $transform->p->y, $y2, "Set position y" );

$transform->q($R2);
cmp_ok( abs( $transform->q->GetAngle() - $angle2 ),
    "<=", 0.00000001, "Set R angle" );

done_testing;
