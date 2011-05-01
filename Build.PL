use strict;
use warnings;
use Module::Build::WithXSpp;

push @INC, "build";

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
		'ExtUtils::Typemap::STL::String' => '0.04',
    'ExtUtils::Typemap::Basic'       => '0.04',
	},
	extra_linker_flags => [qw(-lBox2D)]
);

$builder->create_build_script();
