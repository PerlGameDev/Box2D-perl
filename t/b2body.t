use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new( 0, -10 );
my $world = Box2D::b2World->new( $vec );

my $body_def = Box2D::b2BodyDef->new();
$body_def->userData       (my $user_data = 'asd');
$body_def->position       (my $position = Box2D::b2Vec2->new(1, 2));
$body_def->angle          (my $angle = 3);
$body_def->linearVelocity (my $linear_velocity = Box2D::b2Vec2->new(4, 5));
$body_def->angularVelocity(my $angular_velocity = 6);
$body_def->linearDamping  (my $linear_damping = 7);
$body_def->angularDamping (my $angular_damping = 8);
$body_def->allowSleep     (1);
$body_def->awake          (1);
$body_def->fixedRotation  (1);
$body_def->bullet         (1);
$body_def->type           (my $type = Box2D::b2_dynamicBody);
$body_def->active         (1);
$body_def->gravityScale   (my $gravity_scale = 9);
my $transform = Box2D::b2Transform->new();
$transform->p($position);
$transform->q->Set($angle);

my $body = $world->CreateBody($body_def);
isa_ok( $body, "Box2D::b2Body" );

my $fixture_def = Box2D::b2FixtureDef->new();
$fixture_def->shape( Box2D::b2EdgeShape->new() );
my $fixture = $body->CreateFixture( $fixture_def );
is( ${$body->GetFixtureList()}, $$fixture, "CreateFixture b2FixtureDef" );

my $shape = Box2D::b2CircleShape->new();
my $density = 10;

{
	my $fixture2 = $body->CreateFixture( $shape, $density );
	is( ${$body->GetFixtureList()}, $$fixture2, "CreateFixture b2Shape" );
	is( $body->GetFixtureList()->GetType, $shape->m_type, "CreateFixture b2Shape" );

	my $fixture3 = $fixture2;
	$body->DestroyFixture( $fixture2 );
	is( ${$body->GetFixtureList()}, $$fixture, "DestroyFixture" );
	is( $$fixture2, undef, "DestroyFixture also undefined our reference" );
	is( $$fixture3, undef, "DestroyFixture also undefined our reference" );
}

is( $body->GetTransform()->p->x, $position->x, "GetTransform p" );
is( $body->GetTransform()->p->y, $position->y, "GetTransform p" );
is( $body->GetTransform()->q->GetAngle, $angle, "GetTransform q" );

is( $body->GetPosition()->x, $position->x, "GetPosition" );
is( $body->GetPosition()->y, $position->y, "GetPosition" );

is( $body->GetAngle(), $angle, "GetAngle" );

{
	my $pos = Box2D::b2Vec2->new(30, 31);
	my $ang = 1;
	$body->SetTransform($pos, $ang);

	is( $body->GetTransform()->p->x, $pos->x, "SetTransform p" );
	is( $body->GetTransform()->p->y, $pos->y, "SetTransform p" );
	is( $body->GetTransform()->q->GetAngle, $ang, "SetTransform q" );
	is( $body->GetPosition()->x, $pos->x, "GetPosition" );
	is( $body->GetPosition()->y, $pos->y, "GetPosition" );
	is( $body->GetAngle(), $ang, "GetAngle'" );

	# back to old values
	$body->SetTransform($position, $angle);
}

is( $body->GetWorldCenter->x, $position->x, "GetWorldCenter" );
is( $body->GetWorldCenter->y, $position->y, "GetWorldCenter" );

# this is also tested after SetMassData has been used
is( $body->GetLocalCenter->x, 0, "GetLocalCenter" );
is( $body->GetLocalCenter->y, 0, "GetLocalCenter" );

is( $body->GetLinearVelocity->x, $linear_velocity->x, "GetLinearVelocity" );
is( $body->GetLinearVelocity->y, $linear_velocity->y, "GetLinearVelocity" );
{
	my $v = Box2D::b2Vec2->new(40, 41);
	$body->SetLinearVelocity($v);
	is( $body->GetLinearVelocity->x, $v->x, "SetLinearVelocity" );
	is( $body->GetLinearVelocity->y, $v->y, "SetLinearVelocity" );
	
	# back to old value
	$body->SetLinearVelocity($linear_velocity);
}

is( $body->GetAngularVelocity, $angular_velocity, "GetAngularVelocity" );
{
	my $ang = 42;
	$body->SetAngularVelocity($ang);
	is( $body->GetAngularVelocity(), $ang, "SetAngularVelocity" );
	
	# back to old value
	$body->SetAngularVelocity($angular_velocity);
}

# ApplyForce

# ApplyForceToCenter

# ApplyTorque

# ApplyLinearImpulse

# ApplyAngularImpulse

is( $body->GetMass, 1, "GetMass" );

is( $body->GetInertia, $body->GetMass * Box2D::b2Dot( $body->GetLocalCenter, $body->GetLocalCenter ), "GetInertia" );

{
	my $data = Box2D::b2MassData->new;
	$body->GetMassData($data);
	is( $data->mass, $body->GetMass, "GetMassData mass" );
	is( $data->I, $body->GetInertia, "GetMassData I" );
	is( $data->center->x, $body->GetLocalCenter->x, "GetMassData center" );
	is( $data->center->y, $body->GetLocalCenter->y, "GetMassData center" );

	my $setdata = Box2D::b2MassData->new;
	$setdata->mass(22);
	$setdata->I(1);
	$setdata->center->Set(44, 45);
	$body->SetMassData($setdata);
	
	my $getdata = Box2D::b2MassData->new;
	$body->GetMassData($getdata);
	is( $getdata->mass,      $setdata->mass, "SetMassData mass" );
	is( $getdata->I,         $body->GetInertia, "SetMassData I" );
	is( $getdata->center->x, $setdata->center->x, "SetMassData center" );
	is( $getdata->center->y, $setdata->center->y, "SetMassData center" );
	is( $body->GetLocalCenter->x, $setdata->center->x, "SetMassData GetLocalCenter" );
	is( $body->GetLocalCenter->y, $setdata->center->y, "SetMassData GetLocalCenter" );

	$body->ResetMassData;
	
	my $resetdata = Box2D::b2MassData->new;
	$body->GetMassData($resetdata);
	is( $resetdata->mass,      $data->mass, "GetMassData mass" );
	is( $resetdata->I,         $data->I, "GetMassData I" );
	is( $resetdata->center->x, $data->center->x, "GetMassData center" );
	is( $resetdata->center->y, $data->center->y, "GetMassData center" );
}

{
	my $local_point = Box2D::b2Vec2->new(3, 53);
	is( $body->GetWorldPoint($local_point)->x, Box2D::b2Mul($transform, $local_point)->x, "GetWorldPoint" );
	is( $body->GetWorldPoint($local_point)->y, Box2D::b2Mul($transform, $local_point)->y, "GetWorldPoint" );
}

{
	my $local_vector = Box2D::b2Vec2->new(14, 45);
	is( $body->GetWorldVector($local_vector)->x, Box2D::b2Mul($transform->q, $local_vector)->x, "GetWorldVector" );
	is( $body->GetWorldVector($local_vector)->y, Box2D::b2Mul($transform->q, $local_vector)->y, "GetWorldVector" );
}

{
	my $world_point = Box2D::b2Vec2->new(19, 17);
	is( $body->GetLocalPoint($world_point)->x, Box2D::b2MulT($transform, $world_point)->x, "GetLocalPoint" );
	is( $body->GetLocalPoint($world_point)->y, Box2D::b2MulT($transform, $world_point)->y, "GetLocalPoint" );
}

{
	my $world_vector = Box2D::b2Vec2->new(16, 9);
	is( $body->GetLocalVector($world_vector)->x, Box2D::b2MulT($transform->q, $world_vector)->x, "GetLocalVector" );
	is( $body->GetLocalVector($world_vector)->y, Box2D::b2MulT($transform->q, $world_vector)->y, "GetLocalVector" );
}

# Can't get this to work
# {
	## return m_linearVelocity + b2Cross(m_angularVelocity, worldPoint - m_sweep.c);
	# my $world_point = Box2D::b2Vec2->new(-8, 4);
	# diag 'world-point ', $world_point->x, ' ', $world_point->y;
	# diag 'world-center ', $body->GetWorldCenter()->x, ' ', $body->GetWorldCenter()->y;
	# diag 'wp - wc ', ($world_point - $body->GetWorldCenter)->x, ' ', ($world_point - $body->GetWorldCenter)->y;
	# diag 'angvel ', $body->GetAngularVelocity;
	# diag 'angvel x (wp - wc) ', Box2D::b2Cross($body->GetAngularVelocity, $world_point - $body->GetWorldCenter)->x, ' ', Box2D::b2Cross($body->GetAngularVelocity, $world_point - $body->GetWorldCenter)->y;
	# diag 'linvel ', $body->GetLinearVelocity->x, ' ', $body->GetLinearVelocity->y;
	# my $want = $body->GetLinearVelocity + Box2D::b2Cross($body->GetAngularVelocity, $world_point - $body->GetWorldCenter);
	# diag 'want ', $want->x, ' ', $want->y;
	# my $got = $body->GetLinearVelocityFromWorldPoint($body->GetWorldPoint($world_point));
	# diag 'got ', $got->x, ' ', $got->y;
	
	# cmp_ok( abs($want->x - $got->x), "<=", 1e-4, "GetLinearVelocityFromWorldPoint" );
	# cmp_ok( abs($want->y - $got->y), "<=", 1e-4, "GetLinearVelocityFromWorldPoint" );
# }

{
	my $local_point = Box2D::b2Vec2->new(43, 5);
	my $want = $body->GetLinearVelocityFromWorldPoint($body->GetWorldPoint($local_point));
	my $got = $body->GetLinearVelocityFromLocalPoint($local_point);
	cmp_ok( abs($want->x - $got->x), "<=", 1e-4, "GetLinearVelocityFromLocalPoint" );
	cmp_ok( abs($want->y - $got->y), "<=", 1e-4, "GetLinearVelocityFromLocalPoint" );
}

is( $body->GetLinearDamping, $linear_damping, "GetLinearDamping" );
{
	my $lin_damp = 50;
	$body->SetLinearDamping($lin_damp);
	is( $body->GetLinearDamping(), $lin_damp, "SetLinearDamping" );
}

is( $body->GetAngularDamping, $angular_damping, "GetAngularDamping" );
{
	my $ang_damp = 51;
	$body->SetAngularDamping($ang_damp);
	is( $body->GetAngularDamping(), $ang_damp, "SetAngularDamping" );
}

is( $body->GetGravityScale, $gravity_scale, "GetGravityScale" );
{
	my $grav_scale = 52;
	$body->SetGravityScale($grav_scale);
	is( $body->GetGravityScale(), $grav_scale, "SetGravityScale" );
}

is( $body->GetType, $type, "GetType" );
{
	my $typ = Box2D::b2_kinematicBody;
	$body->SetType($typ);
	is( $body->GetType(), $typ, "SetType" );
}

ok( $body->IsBullet, "IsBullet" );
{
	$body->SetBullet(0);
	ok( !$body->IsBullet(), "SetBullet" );
	$body->SetBullet(1);
	ok( $body->IsBullet(), "SetBullet" );
}

ok( $body->IsSleepingAllowed, "IsSleepingAllowed" );
{
	$body->SetSleepingAllowed(0);
	ok( !$body->IsSleepingAllowed(), "SetSleepingAllowed" );
	$body->SetSleepingAllowed(1);
	ok( $body->IsSleepingAllowed(), "SetSleepingAllowed" );
}

ok( $body->IsAwake, "IsAwake" );
{
	$body->SetAwake(0);
	ok( !$body->IsAwake(), "SetAwake" );
	$body->SetAwake(1);
	ok( $body->IsAwake(), "SetAwake" );
}

ok( $body->IsActive, "IsActive" );
{
	$body->SetActive(0);
	ok( !$body->IsActive(), "SetActive" );
	$body->SetActive(1);
	ok( $body->IsActive(), "SetActive" );
}

ok( $body->IsFixedRotation, "IsFixedRotation" );
{
	$body->SetFixedRotation(0);
	ok( !$body->IsFixedRotation(), "SetFixedRotation" );
	$body->SetFixedRotation(1);
	ok( $body->IsFixedRotation(), "SetFixedRotation" );
}

ok( $body->IsBullet, "IsBullet" );
{
	$body->SetBullet(0);
	ok( !$body->IsBullet(), "SetBullet" );
	$body->SetBullet(1);
	ok( $body->IsBullet(), "SetBullet" );
}

# already tested GetFixtureList

# GetJointList

# GetContactList

{
	my $body2 = $world->CreateBody( Box2D::b2FixtureDef->new() );
	my $body3 = $world->CreateBody( Box2D::b2FixtureDef->new() );

	is( ${$body3->GetNext()}, $$body2, "GetNext" );
	is( ${$body2->GetNext()}, $$body, "GetNext" );
	is( $body->GetNext(), undef, "GetNext returns undef at end" );
}

is( $body->GetUserData, $user_data, "GetUserData" );
{
	my $data = "somethingelse";
	my $data_copy = $data;
	$body->SetUserData( $data );
	is( $body->GetUserData(), $data_copy, "SetUserData with string" );
	$data = [3];
	is( $body->GetUserData(), $data_copy, "SetUserData with string" );
	$body->SetUserData( $data );
	isa_ok( $body->GetUserData(), ref $data, "SetUserData with ref" );
	is( $body->GetUserData()->[0], $data->[0], "SetUserData with ref" );
	is( $body->GetUserData(), $data, "SetUserData with ref" );
}

is( ${$body->GetWorld()}, $$world, "GetWorld" );

# Dump

done_testing;
