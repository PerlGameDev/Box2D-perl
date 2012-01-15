use strict;
use warnings;
use Box2D;
use Test::More;

my $filter = Box2D::b2Filter->new();
isa_ok( $filter, "Box2D::b2Filter" );

is( $filter->categoryBits, 0x0001, "get categoryBits" );
is( $filter->maskBits,     0xFFFF, "get maskBits" );
is( $filter->groupIndex,   0     , "get groupIndex" );

my ( $categoryBits, $maskBits, $groupIndex ) = ( 0x5, 0x7, -9 );
$filter->categoryBits($categoryBits);
$filter->maskBits($maskBits);
$filter->groupIndex($groupIndex);
is( $filter->categoryBits, $categoryBits, "set categoryBits" );
is( $filter->maskBits,     $maskBits,     "set maskBits" );
is( $filter->groupIndex,   $groupIndex,   "set groupIndex" );

done_testing;
