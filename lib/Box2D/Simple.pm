use strict;
use warnings;

package Box2D::Simple;
use Box2D;


1;
__END__

=head1 NAME

Box2D::Simple - Physics Engine, with sugar


=head1 SYNOPSIS

  use Box2D::Simple;   # imports 'world'

  world->gravity( 0, -10 );

  my $platform = world->create_static( width => 10, height => 3, x => 100, y => 50 );

  my $ball = world->create_dynamic( radius => 5, friction => 0.0 );

  # then, in your game loop
  world->update;


=head1 DESCRIPTION

This module is meant to make the most frequent Box2D usages
simpler and easier to accomplish in Perl. For a 1:1 interface with the
C++ library, look at L<Box2D>.

=head1 THE WORLD

Box2D::Simple imports a single function: C<world()>. You use it to set
your gravity, create bodies, etc.

=head2 gravity

  my ($x, $y) = world->gravity();

  world->gravity( $x, $y );

=head2 update

Time step - performs collision detection, integration, and constraint
solution. You should put this somewhere in your movement loop.

Your world is useless unless there are some bodies to interact.
Box2D::Simple provides the following shortcuts to body creation:

=head2 create_static

=head2 create_kinematic

=head2 create_dynamic

Which behave exactly the same as C<create_body()> with the given type
specified. See below for further information:

=head2 create_body

  world->create_body( type => 'static' )

Creates a new body in the world. Available options are:

=head3 type

The body type reflects how it's handled by the physics engine. The default
type is 'static'. Here are all available types:

=over 4

=item * 'static' - zero mass, zero velocity, may be manually moved

=item * 'kinematic' - zero mass, non-zero velocity set by user, moved by solver

=item * 'dynamic' - positive mass, non-zero velocity determined by forces, moved by solver

=back

In games, you usually want platforms and such to be static, moving
obstacles/enemies to be kinematic, and players and some in-game objects
to be dynamic.

=head3 shape

  world->create_body( shape => 'box', width => 10, height => 10 );
  world->create_body( shape => 'circle', radius => 10 );
  world->create_body( shape => 'polygon', vertices => [ [1,3], [4,-1], [5,9] ] );

This property defines the shape of the new body. Each shape requires
specific properties to be set regarding the shape's dimensions. The
shape itself is usually ommitted, and determined by the body's
dimesional properties. In other words, the same bodies above could
have been created like:

  world->create_body( width => 10, height => 10 );
  world->create_body( radius => 10 );
  world->create_body( vertices => [ [1,3], [4,-1], [5,9] ] );

For boxes (i.e. rects) it should be noted that width and height are their
B<full> width and height, not half-size like in 1:1 Box2D.

=head3 density

Density is used to compute the mass properties of the parent body. The
density can be zero or positive. Defaults to 0.

=head3 friction

Friction is used to make objects slide along each other realistically.
The friction strength is proportional to the normal force (this is called
Coulomb friction). It is usually set between 0 (off) and 1 (strong), but
can be any non-negative value.

=head3 restitution

Restitution is used to make objects bounce. The restitution value is
usually set to be between 0 and 1. Consider dropping a ball on a table.
A value of zero means the ball won't bounce (inelastic collision). A
value of one means the ball's velocity will be exactly reflected
(perfectly elastic collision).

=head3 bullet


=head1 SEE ALSO

L<Box2D>, L<SDL>, L<OpenGL>.

