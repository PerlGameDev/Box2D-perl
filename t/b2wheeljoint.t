use strict;
use warnings;
use Box2D;
use Test::More;

my $gravity = Box2D::b2Vec2->new( 0.0, 0.0 );
my $world = Box2D::b2World->new($gravity);

my ( $xA, $yA, $xB, $yB ) = ( 10.0, 20.0, 30.0, 40.0 );

my $bodyDefA = Box2D::b2BodyDef->new();
$bodyDefA->position->Set( $xA, $yA );
my $bodyA   = $world->CreateBody($bodyDefA);
my $circleA = Box2D::b2CircleShape->new();
$circleA->m_radius(50.0);
$bodyA->CreateFixture( $circleA, 0.0 );

my $bodyDefB = Box2D::b2BodyDef->new();
$bodyDefB->position->Set( $xB, $yB );
$bodyDefB->type(Box2D::b2_dynamicBody);
my $bodyB   = $world->CreateBody($bodyDefB);
my $circleB = Box2D::b2CircleShape->new();
$circleB->m_radius(50.0);
$bodyB->CreateFixture( $circleB, 1.0 );

my $anchor = Box2D::b2Vec2->new( ( $xA + $xB ) / 2.0, ( $yA + $yB ) / 2.0 );
my $axis = Box2D::b2Vec2->new( $xA - $xB, $yA - $yB );

my $jointDef = Box2D::b2WheelJointDef->new();
ok( $jointDef, "new" );
isa_ok( $jointDef, "Box2D::b2WheelJointDef" );

is( $jointDef->type, Box2D::e_wheelJoint, "type" );

$jointDef->Initialize( $bodyA, $bodyB, $anchor, $axis );
pass("Initialize");

is( $jointDef->localAnchorA->x,
    $anchor->x - $bodyA->GetWorldCenter->x,
    "get localAnchorA->x"
);
is( $jointDef->localAnchorA->y,
    $anchor->y - $bodyA->GetWorldCenter->y,
    "get localAnchorA->y"
);
is( $jointDef->localAnchorB->x,
    $anchor->x - $bodyB->GetWorldCenter->x,
    "get localAnchorB->x"
);
is( $jointDef->localAnchorB->y,
    $anchor->y - $bodyB->GetWorldCenter->y,
    "get localAnchorB->y"
);

is( $jointDef->localAxisA->x, $axis->x, "get localAxisA->x" );
is( $jointDef->localAxisA->y, $axis->y, "get localAxisA->y" );

my ( $motorSpeed, $maxMotorTorque, $frequencyHz, $dampingRatio )
    = ( 11.0, 13.0, 14.0, 15.0 );

$jointDef->enableMotor(1);
pass("set enableMotor");
ok( $jointDef->enableMotor, "get enableMotor" );
$jointDef->enableMotor(0);
ok( !$jointDef->enableMotor, "get enableMotor" );
$jointDef->enableMotor(1);

$jointDef->maxMotorTorque($maxMotorTorque);
pass("set maxMotorTorque");
is( $jointDef->maxMotorTorque, $maxMotorTorque, "get maxMotorTorque" );

$jointDef->motorSpeed($motorSpeed);
pass("set motorSpeed");
is( $jointDef->motorSpeed, $motorSpeed, "get motorSpeed" );

$jointDef->frequencyHz($frequencyHz);
pass("set motorSpeed");
is( $jointDef->motorSpeed, $motorSpeed, "get motorSpeed" );

$jointDef->dampingRatio($dampingRatio);
pass("set dampingRatio");
is( $jointDef->dampingRatio, $dampingRatio, "get dampingRatio" );

my $joint = $world->CreateJoint($jointDef);
ok( $joint, "Box2D::b2World->CreateJoint" );
isa_ok( $joint, "Box2D::b2Joint" );

bless $joint, "Box2D::b2WheelJoint";
isa_ok( $joint, "Box2D::b2WheelJoint" );

is( $joint->GetAnchorA->x, $anchor->x, "GetAnchorA->x" );
is( $joint->GetAnchorA->y, $anchor->y, "GetAnchorA->y" );
is( $joint->GetAnchorB->x, $anchor->x, "GetAnchorB->x" );
is( $joint->GetAnchorB->y, $anchor->y, "GetAnchorB->y" );

ok( $joint->IsMotorEnabled(), "IsMotorEnabled" );
$joint->EnableMotor(0);
pass("EnableMotor");
ok( !$joint->IsMotorEnabled(), "IsMotorEnabled" );
$joint->EnableMotor(1);
ok( $joint->IsMotorEnabled(), "IsMotorEnabled" );

is( $joint->GetMotorSpeed(), $motorSpeed, "GetMotorSpeed" );
my $speed = 15.0;
$joint->SetMotorSpeed($speed);
pass("SetMotorSpeed");
is( $joint->GetMotorSpeed(), $speed, "GetMotorSpeed" );

$maxMotorTorque++;
$joint->SetMaxMotorTorque($maxMotorTorque);
is( $joint->GetMaxMotorTorque(), $maxMotorTorque, "GetMaxMotorTorque" );

is( $joint->GetSpringFrequencyHz(), $frequencyHz, "GetSpringFrequencyHz" );
$frequencyHz++;
$joint->SetSpringFrequencyHz($frequencyHz);
is( $joint->GetSpringFrequencyHz(), $frequencyHz, "SetSpringFrequencyHz" );

is( $joint->GetSpringDampingRatio(), $dampingRatio, "GetSpringDampingRatio" );
$dampingRatio++;
$joint->SetSpringDampingRatio($dampingRatio);
is( $joint->GetSpringDampingRatio(), $dampingRatio, "SetSpringDampingRatio" );

done_testing;
