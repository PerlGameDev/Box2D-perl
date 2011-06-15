use strict;
use warnings;
use Box2D;
use SDL;
use SDL::Video;
use SDL::Event;
use SDL::Events;
use SDLx::App;
use SDLx::FPS;

my $width  = 300;
my $height = 300;

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
    x0     => $width / 2,
    y0     => $height / 2,
    radius => 20,
    color  => 0x5CCC00FF,
};
$pivot->{body}   = make_static_circle( @$pivot{qw( x0 y0 radius )} );
$pivot->{anchor} = Box2D::b2Vec2->new( @$pivot{qw( x0 y0 )} );

my $bob = {
    x0     => $width - 40,
    y0     => $height / 2,
    radius => 10,
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
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
);

my $_fps = SDLx::FPS->new( fps => $fps );
my $event = SDL::Event->new();

my $realFps = $fps;
my $frames  = 1;
my $ticks   = SDL::get_ticks();

while (1) {
    SDL::Events::pump_events();
    while ( SDL::Events::poll_event($event) ) {
        my $type = $event->type();
        exit if $type == SDL_QUIT;
    }

    $world->Step( $timestep, $vIters, $pIters );
    $world->ClearForces();

    my $p1 = $pivot->{body}->GetPosition();
    my $p2 = $bob->{body}->GetPosition();

    # clear surface
    $app->draw_rect( undef, 0x000000FF );

    $app->draw_line( [ $p1->x, $height - $p1->y ],
        [ $p2->x, $height - $p2->y ], $rodColor );
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

    $_fps->delay();

    $frames++;
}

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
    $y = $height - $y;
    my ( $r, $c ) = @$circle{qw( radius color )};
    $app->draw_circle_filled( [ $x, $y ], $r, $c );
}
