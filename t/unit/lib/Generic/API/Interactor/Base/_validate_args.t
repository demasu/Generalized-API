#!/usr/bin/cpanel-perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../../../../../../lib";

use Generic::API::Interactor::Base;

use Test::Exception;
use Test::More tests => 9;

{
    my $label = 'Positive test';

    my $args = {
        'function'   => 'order',
        'func-value' => 'pro',
        'api'        => 'this_api_file.json',
    };
    my $ret = Generic::API::Interactor::Base::_validate_args($args);
    ok($ret, "$label: _validate_args returns 1 when passed good arguments");

    undef $args;
    $args->{'api'} = 'WhAtEvEr.json';
    lives_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        "$label: _validate_args does not throw an error when api is the only argument passed"
    );
}

{
    my $label = 'Negative test';

    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args() },
        qr/Expecting\s+array\s+or\s+hash\s+reference/i,
        "$label: _validate_args dies when there are no arguments"
    );

    my $args = {};
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/Mandatory\s+parameter.*api.*missing/i,
        "$label: _validate_args throws the proper error when the arguments are empty"
    );

    $args->{'api'} = '';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/The.*api.*parameter.*did\s+not\s+pass/i,
        "$label: _validate_args throws the proper error when the api key is defined, but empty"
    );

    $args->{'api'} = 'Api_file.txt';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/The.*api.*parameter.*api_file.*did\s+not\s+pass/i,
        "$label: _validate_args throws the proper error when the api value does not end in .json"
    );

    $args->{'api'} = 'file.json';
    $args->{'func-value'} = 'something';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/Parameter.*func-value.*depends\s+on\s+parameter.*function.*not\s+given/i,
        "$label: _validate_args throws the proper error when func-value is defined, but function is not"
    );

    $args = {
        'api'        => 'file.json',
        'function'   => '',
        'func-value' => '',
    };
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/The.*function.*parameter.*did\s+not\s+pass/i,
        "$label: _validate_args throws the proper error when all keys are there, but function and func-value are empty"
    );

    $args->{'function'} = 'func1';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/The.*func-value.*parameter.*did\s+not\s+pass/i,
        "$label: _validate_args throws the proper error when func-value has an empty value"
    );
}
