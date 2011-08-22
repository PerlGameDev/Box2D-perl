use strict;
use warnings;
use Box2D;
use Test::More;

my $gravity = Box2D::b2Vec2->new( 0, 10 );
my $world = Box2D::b2World->new( $gravity, 1 );

my $bodyDef = Box2D::b2BodyDef->new();
$bodyDef->position->Set( 5, 5 );
my $body = $world->CreateBody($bodyDef);

my $shape = Box2D::b2PolygonShape->new();
$shape->SetAsBox( 2, 2 );

$body->CreateFixture( $shape, 1.0 );

my $point1 = Box2D::b2Vec2->new( 0,  0 );
my $point2 = Box2D::b2Vec2->new( 10, 10 );

my $reported;

my $callback = Box2D::PerlRayCastCallback->new(
    sub {
        my ( $fixture, $point, $normal, $fraction ) = @_;

        $reported = 1;

        return 0;
    }
);

ok( $callback, "new" );
isa_ok( $callback, "Box2D::PerlRayCastCallback" );

$world->RayCast( $callback, $point1, $point2 );

ok( $reported, "RayCast" );

done_testing;
