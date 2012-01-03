use strict;
use warnings;
use Box2D;
use Test::More;

my $version = Box2D::b2Version->new();

isa_ok( $version, "Box2D::b2Version", "Box2D::b2Version->new()" );

$version->major(9);      pass("version->major set to 9");
$version->minor(88);     pass("version->minor set to 88");
$version->revision(777); pass("version->revision set to 777");

is( $version->major,      9, "version->major is 9");
is( $version->minor,     88, "version->major is 88");
is( $version->revision, 777, "version->major is 777");

my $current = Box2D::b2_version();
isa_ok( $current, "Box2D::b2Version", "Box2D::b2_version()" );

diag( sprintf("%s.%s.%s", $current->major, $current->minor, $current->revision) );

pass("cleanup");

done_testing;
