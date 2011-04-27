use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new(10,10);
my $world = Box2D::b2World->new($vec, 1);

my $body_def = Box2D::b2BodyDef->new();

	$body_def->position->Set(0.0, -10.0);

my $body = $world->CreateBody($body_def); 

isa_ok( $body, "Box2D::b2Body" );
pass("Made stuff and survived");

done_testing;
