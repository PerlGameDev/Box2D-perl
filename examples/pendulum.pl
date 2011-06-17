# This example uses b2DistanceJoint to simulate a simple pendulum.
use strict;
use warnings;
use Box2D;
use SDL;
use SDL::Video;
use SDLx::App;

# pixels
my $width  = 300;
my $height = 300;

# pixels per meter
my $ppm = 30;

# meters per pixel
my $mpp = 1.0 / $ppm;

# frames per second
my $fps      = 60.0;
my $timestep = 1.0 / $fps;

# velocity iterations
my $vIters = 10;

# position iterations
my $pIters = 10;

my $gravity = Box2D::b2Vec2->new( 0, -10.0 );
my $world = Box2D::b2World->new( $gravity, 1 );

my $rodColor = 0x00CC70FF;

my $pivot = {
    x0     => s2w( $width / 2 ),
    y0     => s2w( $height / 2 ),
    radius => s2w(4),
    color  => 0x5CCC00FF,
};
$pivot->{body}   = make_static_circle( @$pivot{qw( x0 y0 radius )} );
$pivot->{anchor} = Box2D::b2Vec2->new( @$pivot{qw( x0 y0 )} );

my $bob = {
    x0     => s2w( $width - 40 ),
    y0     => s2w( $height / 2 ),
    radius => s2w(10),
    color  => 0xCC005CFF,
};
$bob->{body}   = make_dynamic_circle( @$bob{qw( x0 y0 radius )} );
$bob->{anchor} = Box2D::b2Vec2->new( @$bob{qw( x0 y0 )} );

my $jointDef = Box2D::b2DistanceJointDef->new();
$jointDef->Initialize( $pivot->{body}, $bob->{body}, $pivot->{anchor},
    $bob->{anchor} );
$jointDef->frequencyHz(4.0);
$jointDef->dampingRatio(0.5);
$world->CreateJoint($jointDef);

my $app = SDLx::App->new(
    width  => $width,
    height => $height,
    dt     => $timestep,
    min_t  => $timestep / 2,
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
    eoq    => 1,
);

my $realFps = $fps;
my $frames  = 1;
my $ticks   = SDL::get_ticks();

$app->add_show_handler(
    sub {
        $world->Step( $timestep, $vIters, $pIters );
        $world->ClearForces();

        my $p1 = $pivot->{body}->GetPosition();
        my $p2 = $bob->{body}->GetPosition();

        # clear surface
        $app->draw_rect( undef, 0x000000FF );

        $app->draw_line( [ w2s( $p1->x ), w2s( s2w($height) - $p1->y ) ],
            [ w2s( $p2->x ), w2s( s2w($height) - $p2->y ) ], $rodColor );
        draw_circle($pivot);
        draw_circle($bob);

        if ( $frames % $fps == 0 ) {
            my $t = SDL::get_ticks();
            $realFps = $fps / ( $t - $ticks ) * 1000;
            $ticks = $t;
        }
        $app->draw_gfx_text( [ 10, 10 ],
            0xFFFFFFFF, sprintf( "FPS: %0.2f", $realFps ) );

        $app->update();

        $frames++;
    }
);

$app->run();

# screen to world
sub s2w { return $_[0] * $mpp }

# world to screen
sub w2s { return $_[0] * $ppm }

sub make_static_circle {
    my ( $x, $y, $r ) = @_;

    my $bodyDef = Box2D::b2BodyDef->new();
    $bodyDef->position->Set( $x, $y );
    my $body = $world->CreateBody($bodyDef);

    my $circle = Box2D::b2CircleShape->new();
    $circle->m_radius($r);

    $body->CreateFixture( $circle, 0.0 );

    return $body;
}

sub make_dynamic_circle {
    my ( $x, $y, $r ) = @_;

    my $bodyDef = Box2D::b2BodyDef->new();
    $bodyDef->type(Box2D::b2_dynamicBody);
    $bodyDef->position->Set( $x, $y );
    $bodyDef->linearDamping(0.1);
    $bodyDef->angularDamping(0.1);
    my $body = $world->CreateBody($bodyDef);

    my $circle = Box2D::b2CircleShape->new();
    $circle->m_radius($r);

    $body->CreateFixture( $circle, 1.0 );

    return $body;
}

sub draw_circle {
    my ($circle) = @_;
    my $p = $circle->{body}->GetPosition();
    my ( $x, $y ) = ( $p->x, $p->y );
    $y = s2w($height) - $y;
    my ( $r, $c ) = @$circle{qw( radius color )};
    $app->draw_circle_filled( [ w2s($x), w2s($y) ], w2s($r), $c );
}
