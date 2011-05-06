package Box2D;

use warnings;
use strict;
our @ISA = qw(Exporter);

=head1 NAME

Box2D - 2D Physics Library

=cut

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Box2D', $VERSION);
require Exporter;

our @EXPORT_OK   = ();
our %EXPORT_TAGS = ( );

use constant {
#b2Body Type 
b2_staticBody => 0,
b2_kinematicBody => 1,
b2_dynamicBody => 2,

#b2Shape Type 
e_unknown=> -1,
e_circle => 0,
e_polygon => 1,
e_typeCount => 2,

};

BEGIN {
*Box2D::b2World::SetContactListener = sub{
    if (UNIVERSAL::isa($_[1],"Box2D::b2ContactListener")) {
        $_[0]->SetContactListenerXS( $_[1]->_getListener() );
    } else {
        $_[0]->SetContactListenerXS( $_[1] );
    }
};
}

1; # End of Box2D
