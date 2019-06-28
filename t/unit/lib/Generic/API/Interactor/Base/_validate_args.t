#!/usr/bin/cpanel-perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../../../../../../lib";

use Generic::API::Interactor::Base;

use Test::Exception;
use Test::More tests => 8;

{
    my $label = 'Positive test';

    my $args = {
        'function'   => 'order',
        'func-value' => 'pro',
        'api'        => 'this_api_file.json',
    };
    my $ret = Generic::API::Interactor::Base::_validate_args($args);
    ok($ret, "$label: _validate_args returns 1 when passed good arguments");
}

{
    my $label = 'Negative test';

    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args() },
        qr/the\s+parameters.*function.*func-value.*api.*required/i,
        "$label: _validate_args dies when there are no arguments"
    );

    my $args = {
        'function' => 'order',
    };
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameters\s+'func-value.*api.*required/i,
        "$label: _validate_args throws the proper error when two required fields are missing"
    );

    $args = {
        'function'   => 'order',
        'func-value' => 'pro',
    };
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameter\s+'api.*required/i,
        "$label: _validate_args throws the proper error when one required field is missing"
    );

    $args = {
        'function'   => '',
        'func-value' => '',
        'api'        => '',
    };
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameters\s+'function.*func-value.*api.*cannot\s+be\s+empty/i,
        "$label: _validate_args throws the proper error if required fields are missing values"
    );

    $args->{'function'} = 'order';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameters\s+'func-value.*api.*cannot\s+be\s+empty/i,
        "$label: _validate_args throws the proper error if required fields are missing values"
    );

    $args->{'func-value'} = 'pro';
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameter\s+'api.*cannot\s+be\s+empty/i,
        "$label: _validate_args throws the proper error if required fields are missing values"
    );
}

{
    my $label = 'Negative test';

    my $args = {
        'function'   => '',
        'func-value' => 'pro',
    };
    throws_ok(
        sub { Generic::API::Interactor::Base::_validate_args($args) },
        qr/the\s+parameter\s+'api.*required.*the\s+parameter\s+'function.*cannot\s+be\s+empty/is,
        "$label: _validate_args properly throws all errors if there are multiple kinds"
    );
}
