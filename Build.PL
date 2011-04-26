use strict;
use warnings;
use Module::Build::WithXSpp;


my $builder = Module::Build::WithXSpp->new(
    module_name         => 'Box2D',
    license             => 'perl',
    dist_author         => q{Kartik Thakore <kthakore@CPAN.org>},
    dist_version_from   => 'lib/Box2D.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Box2D-*' ],
	extra_typemap_modules => { 
		'ExtUtils::Typemap::ObjectMap' => '0',
	},
	extra_linker_flags => [qw(-lBox2D)]
);

$builder->create_build_script();
