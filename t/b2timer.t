use strict;
use warnings;
use Box2D;
use Test::More;

my $timer = Box2D::b2Timer->new();

isa_ok( $timer, "Box2D::b2Timer", "Box2D::b2Timer->new()" );

$timer->Reset();
pass("timer->Reset");

cmp_ok($timer->GetMilliseconds(), '<', 1000, "timer->GetMilliseconds() is less than 1000");

sleep(3);
pass("sleeping three seconds");

cmp_ok($timer->GetMilliseconds(), '>', 2000, "timer->GetMilliseconds() is greater than 2000");

pass("cleanup");

done_testing;
