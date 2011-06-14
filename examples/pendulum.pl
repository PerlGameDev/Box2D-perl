use strict;
use warnings;
use Box2D;
use SDL;
use SDL::Video;
use SDLx::App;

my $width    = 300;
my $height   = 300;
my $timestep = 1.0 / 60.0;

# velocity iterations
my $vIters = 6;

# position iterations
my $pIters = 6;

my $gravity = Box2D::b2Vec2->new( 0, -10 );
my $world = Box2D::b2World->new( $gravity, 1 );

my $rodColor = 0x00CC70FF;

my $pivot = {
    x0     => $width / 2,
    y0     => $height / 2,
    radius => 10,
    color  => 0x5CCC00FF,
};
$pivot->{body}   = make_static_circle( @$pivot{qw( x0 y0 radius )} );
$pivot->{anchor} = Box2D::b2Vec2->new( @$pivot{qw( x0 y0 )} );

my $bob = {
    x0     => $width - 40,
    y0     => $height / 2,
    radius => 20,
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
    dt     => $timestep,
    min_t  => $timestep / 2,
    width  => $width,
    height => $height,
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
    eoq    => 1,
);

$app->add_move_handler(
    sub {
        $world->Step( $timestep, $vIters, $pIters );
        $world->ClearForces();
    }
);

$app->add_show_handler(
    sub {
        my $p1 = $pivot->{body}->GetPosition();
        my $p2 = $bob->{body}->GetPosition();

        # clear surface
        $app->draw_rect( undef, 0x000000FF );

        $app->draw_line( [ $p1->x, $height - $p1->y ],
            [ $p2->x, $height - $p2->y ], $rodColor );
        draw_circle($pivot);
        draw_circle($bob);

        $app->update();
    }
);

$app->run();

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
