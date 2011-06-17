use strict;
use warnings;
use Box2D;
use Test::More;

my $fixtureDef = Box2D::b2FixtureDef->new();
my $filter = $fixtureDef->filter;

my ( $categoryBits, $maskBits, $groupIndex ) = ( 0x5, 0x7, -9 );
$filter->categoryBits($categoryBits);
$filter->maskBits($maskBits);
$filter->groupIndex($groupIndex);
is( $filter->categoryBits, $categoryBits, "get categoryBits" );
is( $filter->maskBits,     $maskBits,     "get maskBits" );
is( $filter->groupIndex,   $groupIndex,   "get groupIndex" );

done_testing;
