use strict;
use warnings;
use Box2D;
use Test::More;

cmp_ok( Box2D::b2_maxFloat,                  '>',  1e+37,            "Box2D::b2_maxFloat > 1e+37" );
cmp_ok( Box2D::b2_epsilon,                   '<=', 1e-5,             "Box2D::b2_maxFloat <= 1e-5" );

my $b2_pi = Box2D::b2_pi;
_is_nearly( $b2_pi,                          3.14159265359,          "Box2D::b2_pi" );
_is_nearly( Box2D::b2_maxManifoldPoints,     2,                      "Box2D::b2_maxManifoldPoints" );
_is_nearly( Box2D::b2_maxPolygonVertices,    8,                      "Box2D::b2_maxPolygonVertices" );
_is_nearly( Box2D::b2_aabbExtension,         0.1,                    "Box2D::b2_aabbExtension" );
_is_nearly( Box2D::b2_aabbMultiplier,        2.0,                    "Box2D::b2_aabbMultiplier" );

my $b2_lS = Box2D::b2_linearSlop;
_is_nearly( $b2_lS,                          0.005,                  "Box2D::b2_linearSlop" );
_is_nearly( Box2D::b2_angularSlop,           2.0 / 180.0 * $b2_pi,   "Box2D::b2_angularSlop" );
_is_nearly( Box2D::b2_polygonRadius,         2.0 * $b2_lS,           "Box2D::b2_polygonRadius" );
_is_nearly( Box2D::b2_maxSubSteps,           8,                      "Box2D::b2_maxSubSteps" );
_is_nearly( Box2D::b2_maxTOIContacts,        32,                     "Box2D::b2_maxTOIContacts" );
_is_nearly( Box2D::b2_velocityThreshold,     1.0,                    "Box2D::b2_velocityThreshold" );
_is_nearly( Box2D::b2_maxLinearCorrection,   0.2,                    "Box2D::b2_maxLinearCorrection" );
_is_nearly( Box2D::b2_maxAngularCorrection,  8.0 / 180.0 * $b2_pi,   "Box2D::b2_maxAngularCorrection" );

my $b2_mT = Box2D::b2_maxTranslation;
_is_nearly( $b2_mT,                          2.0,                    "Box2D::b2_maxTranslation" );
_is_nearly( Box2D::b2_maxTranslationSquared, $b2_mT * $b2_mT,        "Box2D::b2_maxTranslationSquared" );

my $b2_mR = Box2D::b2_maxRotation;
_is_nearly( $b2_mR,                          0.5 * $b2_pi,           "Box2D::b2_maxRotation" );
_is_nearly( Box2D::b2_maxRotationSquared,    $b2_mR * $b2_mR,        "Box2D::b2_maxRotationSquared" );
_is_nearly( Box2D::b2_baumgarte,             0.2,                    "Box2D::b2_baumgarte" );
_is_nearly( Box2D::b2_toiBaugarte,           0.75,                   "Box2D::b2_toiBaugarte" );
_is_nearly( Box2D::b2_timeToSleep,           0.5,                    "Box2D::b2_timeToSleep" );
_is_nearly( Box2D::b2_linearSleepTolerance,  0.01,                   "Box2D::b2_linearSleepTolerance" );
_is_nearly( Box2D::b2_angularSleepTolerance, (2.0 / 180.0 * $b2_pi), "Box2D::b2_angularSleepTolerance" );

# TODO: Memory Allocation
# void* b2Alloc(int32 size);
# void b2Free(void* mem);
# void b2Log(const char* string, ...);

my $version = Box2D::b2_version();
isa_ok( $version,                                                                "Box2D::b2Version", "Box2D::b2_version()" );
like( $version->major,                                   qr/^\d+$/,              "version->major is a number" );
like( $version->minor,                                   qr/^\d+$/,              "version->minor is a number" );
like( $version->revision,                                qr/^\d+$/,              "version->revision is a number" );
diag( sprintf("%s.%s.%s", $version->major, $version->minor, $version->revision) );

pass("cleanup");

done_testing;

sub _is_nearly {
    my ($a, $b, $c) = @_;
    $a              = int($a * 1000000 + 0.5) / 1000000;
    $b              = int($b * 1000000 + 0.5) / 1000000;
    is( $a, $b, "$c is nearly $b" );
}
