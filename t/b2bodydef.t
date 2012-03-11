use strict;
use warnings;
use Box2D;
use Test::More;

my $body_def = Box2D::b2BodyDef->new();

isa_ok( $body_def, "Box2D::b2BodyDef" );

is( $body_def->position->x,       0,                    "initial position" );
is( $body_def->position->y,       0,                    "initial position" );
is( $body_def->angle,             0,                    "initial angle" );
is( $body_def->linearVelocity->x, 0,                    "initial linearVelocity" );
is( $body_def->linearVelocity->y, 0,                    "initial linearVelocity" );
is( $body_def->angularVelocity,   0,                    "initial angularVelocity" );
is( $body_def->linearDamping,     0,                    "initial linearDamping" );
is( $body_def->angularDamping,    0,                    "initial angularDamping" );
ok( $body_def->allowSleep,                              "initial allowSleep" );
ok( $body_def->awake,                                   "initial awake" );
ok( !$body_def->fixedRotation,                          "initial fixedRotation" );
ok( !$body_def->bullet,                                 "initial bullet" );
is( $body_def->type,              Box2D::b2_staticBody, "initial type" );
ok( $body_def->active,                                  "initial active" );
is( $body_def->gravityScale,      1,                    "initial gravityScale" );

{
	my $data = 1;
	$body_def->userData($data);
	is( $body_def->userData, $data, "userData with scalar" );

	$data = \2;
	$body_def->userData($data);
	isa_ok( $body_def->userData, ref $data, "userData with scalarref" );
	is( ${ $body_def->userData }, $$data, "userData with scalarref" );
	is( $body_def->userData, $data, "userData with scalarref" );

	$data = sub { "test" };
	$body_def->userData($data);
	isa_ok( $body_def->userData, ref $data, "userData with coderef" );
	is( $body_def->userData->(), $data->(), "userData with coderef" );
	is( $body_def->userData, $data, "userData with coderef" );
}

{
	my $type = Box2D::b2_dynamicBody;
	$body_def->type($type);
	is( $body_def->type, $type, "get and set type" );
}

{
	my $position = Box2D::b2Vec2->new(3, 4);
	$body_def->position($position);
	is( $body_def->position->x, $position->x, "get and set position" );
	is( $body_def->position->y, $position->y, "get and set position" );
}

{
	my $angle = 5;
	$body_def->angle($angle);
	is( $body_def->angle, $angle, "get and set angle" );
}

{
	my $linearVelocity = Box2D::b2Vec2->new(6, 7);
	$body_def->linearVelocity($linearVelocity);
	is( $body_def->linearVelocity->x, $linearVelocity->x, "get and set linearVelocity" );
	is( $body_def->linearVelocity->y, $linearVelocity->y, "get and set linearVelocity" );
}

{
	my $angularVelocity = 8;
	$body_def->angularVelocity($angularVelocity);
	is( $body_def->angularVelocity, $angularVelocity, "get and set angularVelocity" );
}

{
	my $linearDamping = 9;
	$body_def->linearDamping($linearDamping);
	is( $body_def->linearDamping, $linearDamping, "get and set linearDamping" );
}

{
	my $angularDamping = 10;
	$body_def->angularDamping($angularDamping);
	is( $body_def->angularDamping, $angularDamping, "get and set angularDamping" );
}

{
	$body_def->allowSleep(0);
	ok( !$body_def->allowSleep, "get and set allowSleep" );
	$body_def->allowSleep(1);
	ok( $body_def->allowSleep, "get and set allowSleep" );
}

{
	$body_def->awake(0);
	ok( !$body_def->awake, "get and set awake" );
	$body_def->awake(1);
	ok( $body_def->awake, "get and set awake" );
}

{
	$body_def->fixedRotation(1);
	ok( $body_def->fixedRotation, "get and set fixedRotation" );
	$body_def->fixedRotation(0);
	ok( !$body_def->fixedRotation, "get and set fixedRotation" );
}

{
	$body_def->bullet(1);
	ok( $body_def->bullet, "get and set bullet" );
	$body_def->bullet(0);
	ok( !$body_def->bullet, "get and set bullet" );
}

{
	$body_def->active(0);
	ok( !$body_def->active, "get and set active" );
	$body_def->active(1);
	ok( $body_def->active, "get and set active" );
}

{
	my $gravityScale = 11;
	$body_def->gravityScale($gravityScale);
	is( $body_def->gravityScale, $gravityScale, "get and set gravityScale" );
}

done_testing;
