use strict;
use warnings;
use Box2D;
use Test::More;

my $gravity = Box2D::b2Vec2->new( 0.0, 0.0 );
my $world = Box2D::b2World->new( $gravity );

my ( $xA, $yA, $xB, $yB ) = ( 10.0, 20.0, 30.0, 40.0 );

my $bodyDefA = Box2D::b2BodyDef->new();
$bodyDefA->position->Set( $xA, $yA );
my $bodyA   = $world->CreateBody($bodyDefA);
my $circleA = Box2D::b2CircleShape->new();
$circleA->m_radius(5.0);
$bodyA->CreateFixture( $circleA, 0.0 );

my $bodyDefB = Box2D::b2BodyDef->new();
$bodyDefB->position->Set( $xB, $yB );
$bodyDefB->type(Box2D::b2_dynamicBody);
my $bodyB   = $world->CreateBody($bodyDefB);
my $circleB = Box2D::b2CircleShape->new();
$circleB->m_radius(5.0);
$bodyB->CreateFixture( $circleB, 1.0 );

my $anchor = Box2D::b2Vec2->new( ( $xA + $xB ) / 2.0, ( $yA + $yB ) / 2.0 );

my $jointDef = Box2D::b2WeldJointDef->new();
ok( $jointDef, "new" );
isa_ok( $jointDef, "Box2D::b2WeldJointDef" );

$jointDef->Initialize( $bodyA, $bodyB, $anchor );
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

my $referenceAngle = 0.5;

$jointDef->referenceAngle($referenceAngle);
pass("set referenceAngle");
is( $jointDef->referenceAngle, $referenceAngle, "get referenceAngle" );

my $joint = $world->CreateJoint($jointDef);
ok( $joint, "Box2D::b2World->CreateJoint" );
isa_ok( $joint, "Box2D::b2Joint" );

bless $joint, "Box2D::b2WeldJoint";
isa_ok( $joint, "Box2D::b2WeldJoint" );

is( $joint->GetAnchorA->x, $anchor->x, "GetAnchorA->x" );
is( $joint->GetAnchorA->y, $anchor->y, "GetAnchorA->y" );
is( $joint->GetAnchorB->x, $anchor->x, "GetAnchorB->x" );
is( $joint->GetAnchorB->y, $anchor->y, "GetAnchorB->y" );

done_testing;
