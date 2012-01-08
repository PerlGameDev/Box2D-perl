use strict;
use warnings;
use Box2D;
use Test::More;

my $rope     = Box2D::b2Rope->new();
my $rope_def = Box2D::b2RopeDef->new();

isa_ok(     $rope,                 "Box2D::b2Rope",    "Box2D::b2Rope->new" );
isa_ok(     $rope_def,             "Box2D::b2RopeDef", "Box2D::b2RopeDef->new" );
is(         $rope_def->vertices,   undef,              "Box2D::b2RopeDef->vertices is undef" );
is(         $rope_def->count,      0,                  "Box2D::b2RopeDef->count is 0" );
is(         $rope_def->masses,     0,                  "Box2D::b2RopeDef->masses is 0" );
isa_ok(     $rope_def->gravity,    "Box2D::b2Vec2",    "Box2D::b2RopeDef->gravity" );
is(         $rope_def->gravity->x, 0,                  "Box2D::b2RopeDef->gravity->x is 0" );
is(         $rope_def->gravity->y, 0,                  "Box2D::b2RopeDef->gravity->y is 0" );
_is_nearly( $rope_def->damping,    0.1,                "Box2D::b2RopeDef->vertices" );
_is_nearly( $rope_def->k2,         0.9,                "Box2D::b2RopeDef->vertices" );
_is_nearly( $rope_def->k3,         0.1,                "Box2D::b2RopeDef->vertices" );


pass("cleanup");

done_testing;

sub _is_nearly {
    my ($a, $b, $c) = @_;
    $a              = int($a * 1000000 + 0.5) / 1000000;
    $b              = int($b * 1000000 + 0.5) / 1000000;
    is( $a, $b, "$c is nearly $b" );
}
