use strict;
use warnings;
use Box2D;
use Test::More;

my ( $w, $h ) = ( 10.0, 12.0 );
my $rect = Box2D::b2PolygonShape->new();
$rect->SetAsBox( $w / 2.0, $h / 2.0 );
pass("SetAsBox");

is( $rect->GetVertexCount, 4, "GetVertexCount" );

foreach ( 0 .. 3 ) {
    my $vertex = $rect->GetVertex($_);
    isa_ok( $vertex, "Box2D::b2Vec2" );
    is( abs( $vertex->x ), $w / 2 );
    is( abs( $vertex->y ), $h / 2 );
}

done_testing;
