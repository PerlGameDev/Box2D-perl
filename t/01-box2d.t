use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec2->new(10,10);
my $world = Box2D::b2World->new($vec, 1);

pass("Made stuff and survided");

done_testing;
