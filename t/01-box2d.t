use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new(10,10);
my $world = Box2D::b2World->new($vec, 1);

my $body_def = Box2D::b2BodyDef->new();

$body_def->position->Set(0.0, -10.0);

my $groundBody = $world->CreateBody($body_def); 

my $groundBox = Box2D::b2PolygonShape->new();

$groundBox->SetAsBox(50.0, 10.0);

$groundBody->CreateFixture( $groundBox, 0.0 ); 

my $bodyDef = Box2D::b2BodyDef->new();
	$bodyDef->type(Box2D::b2_dynamicBody);
	is( $bodyDef->type(), 2, "returning enum" );
	$bodyDef->position->Set(0.0, 4.0);

pass("Made stuff and survived");

done_testing;
