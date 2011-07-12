use strict;
use warnings;
use Box2D;
use SDL;
use SDL::Video;
use SDL::Events qw(:type);
use SDLx::App;

# pixels
my $width  = 400;
my $height = 400;

# pixels per meter
my $ppm = 10;

# meters per pixel
my $mpp = 1.0 / $ppm;

# frames per second
my $fps      = 60.0;
my $timestep = 1.0 / $fps;

# velocity iterations
my $vIters = 30;

# position iterations
my $pIters = 30;

my $gravity = make_vec2( 0.0, 0.0 );
my $world = Box2D::b2World->new( $gravity, 1 );

my $ground = make_ground();

my $ball = make_ball(
    x       => s2w( $width / 2.0 ),
    y       => s2w( $height / 2.0 ),
    radius  => s2w( rand(5.0) + 5.0 ),
    color   => [ int rand(255), int rand(255), int rand(255) ],
    density => 1.0,
);

my $joint = make_mouse_joint(
    target   => $ball->{body}->GetWorldCenter(),
    bodyA    => $ground->{body},
    bodyB    => $ball->{body},
    maxForce => 1000.0 * $ball->{body}->GetMass(),
);

my $app = SDLx::App->new(
    width  => $width,
    height => $height,
    dt     => $timestep,
    min_t  => $timestep / 2,
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
    eoq    => 1,
);

$app->add_event_handler(
    sub {
        my ($event) = @_;
        return unless $event->type == SDL_MOUSEMOTION;
        my ( undef, $x, $y ) = @{ SDL::Events::get_mouse_state() };
        $joint->SetTarget( make_vec2( s2w($x), s2w($y) ) );
    }
);

$app->add_show_handler(
    sub {
        $world->Step( $timestep, $vIters, $pIters );
        $world->ClearForces();

        # clear surface
        $app->draw_rect( undef, 0x000000FF );

        draw_circle($ball);

        $app->update();
    }
);

$app->run();

# screen to world
sub s2w { return $_[0] * $mpp }

# world to screen
sub w2s { return $_[0] * $ppm }

sub make_vec2 {
    my ( $x, $y ) = @_;
    return Box2D::b2Vec2->new( $x, $y );
}

sub make_ground {
    my $body = make_body(
        x => $width / 2.0,
        y => $height,
    );
    my $edge
        = make_edge( [ 0.0, s2w($height) ], [ s2w($width), s2w($height) ] );
    my $fixture = make_fixture(
        shape => $edge,
        body  => $body,
    );
    return {
        shape   => $edge,
        body    => $body,
        fixture => $fixture,
    };
}

sub make_ball {
    my (%options) = @_;
    my ( $x, $y, $r, $d ) = @options{qw( x y radius density )};

    my $body = make_body(
        x    => $x,
        y    => $y,
        type => 'dynamic',
    );

    my $circle = make_circle( radius => $r );

    my $fixture = make_fixture(
        shape   => $circle,
        body    => $body,
        density => $d,
    );

    return {
        body   => $body,
        shape  => $circle,
        fiture => $fixture,
        color  => $options{color},
    };
}

# shapes
sub make_edge {
    my ( $p1, $p2 ) = @_;
    my $edge = Box2D::b2PolygonShape->new();
    $edge->SetAsEdge( make_vec2(@$p1), make_vec2(@$p2) );
    return $edge;
}

sub make_circle {
    my (%options) = @_;
    my $circle = Box2D::b2CircleShape->new();
    $circle->m_radius( $options{radius} );
    return $circle;
}

# bodies
sub make_body {
    my (%options) = @_;
    my ( $x, $y ) = @options{qw( x y )};
    my $bodyDef = Box2D::b2BodyDef->new();
    $bodyDef->position->Set( $x, $y );
    $bodyDef->type(Box2D::b2_dynamicBody)
        if exists $options{type} && $options{type} eq 'dynamic';
    return $world->CreateBody($bodyDef);
}

# fixtures
sub make_fixture {
    my (%options) = @_;
    my ( $shape, $body, $density ) = @options{qw( shape body density )};
    my $fixtureDef = Box2D::b2FixtureDef->new();
    $fixtureDef->shape($shape);
    $fixtureDef->density($density);
    return $body->CreateFixtureDef($fixtureDef);
}

# joints
sub make_mouse_joint {
    my (%options) = @_;
    my $jointDef = Box2D::b2MouseJointDef->new();
    $jointDef->bodyA( $options{bodyA} )       if exists $options{bodyA};
    $jointDef->bodyB( $options{bodyB} )       if exists $options{bodyB};
    $jointDef->target( $options{target} )     if exists $options{target};
    $jointDef->maxForce( $options{maxForce} ) if exists $options{maxForce};
    $jointDef->frequencyHz( $options{frequencyHz} )
        if exists $options{frequencyHz};
    $jointDef->dampingRatio( $options{dampingRatio} )
        if exists $options{dampingRatio};
    my $joint = $world->CreateJoint($jointDef);
    return bless $joint, 'Box2D::b2MouseJoint';
}

# drawing
sub draw_circle {
    my ($circle) = @_;
    my ( $body, $shape, $c ) = @$circle{qw( body shape color )};
    my $p = $body->GetPosition();
    my ( $x, $y ) = ( $p->x, $p->y );
    my $r = $shape->m_radius;
    $app->draw_circle_filled( [ w2s($x), w2s($y) ], w2s($r), $c );
}
