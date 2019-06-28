#!/usr/bin/cpanel-perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../../../../../../lib";

use Test::Deep;
use Test::MockModule;
use Test::More;

my $mgab = Test::MockModule->new('Generic::API::Interactor::Base');

{
    my $label = 'Positive test';

    my $gaib = Generic::API::Interactor::Base->new();
    isa_ok( $gaib, 'Generic::API::Interactor::Base', "$label: new creates a proper object" );
}

{
    my $label = 'Positive test';

    do_mocking();
    my $args = {
        'function'   => 'order',
        'func-value' => 'pro',
        'api'        => 'this_is_an_api.json',
    };
    my $gaib = Generic::API::Interactor::Base->new($args);
    isa_ok( $gaib, 'Generic::API::Interactor::Base', "$label: new creates a proper object when passed arguments" );

    my $tests = noclass({
        'function'   => 'order',
        'func-value' => 'pro',
        'api'        => 'this_is_an_api.json',
    });
    cmp_deeply( $gaib, $tests, "$label: new populates the object from the arguments properly" );
}

done_testing();

sub do_mocking {
    $mgab->noop('_validate_args');
}
