package Generic::API::Form::Parse;

use strict;
use warnings;

sub parse {
    my ($data) = @_;

    my %obj;

    $obj{'api_name'} = $data->{'api-name'};
    $obj{'base_url'} = $data->{'base-url'};
    $obj{'query_method'} = $data->{'query-method'};
    $obj{'username'} = $data->{'username'};
    $obj{'password'} = $data->{'password'};
    $obj{'order'} = {
        'call' => $data->{'order-call'},
        'params' => [],
    };
    $obj{'cancel'} = {
        'call' => $data->{'cancel-call'},
        'params' => [],
    };

    my $ret = \%obj;
    $ret    = _parse_order_params($ret, $data);
    $ret    = _parse_cancel_params($ret, $data);

    return $ret;
}

sub _parse_order_params {
    my ($obj, $data) = @_;

    $obj = _parse_params($obj, 'order', $data);

    return $obj;
}

sub _parse_cancel_params {
    my ($obj, $data) = @_;

    $obj = _parse_params($obj, 'cancel', $data);

    return $obj;
}

sub _parse_params {
    my ($obj, $type, $data) = @_;

    my @params = grep { $_ =~ /^\Q$type\E-param-/ } keys (%{$data});

    foreach my $param ( @params ) {
        my $required = 'required-' . $param;
        my $item = {
            'name'     => $data->{$param},
            'required' => $data->{$required},
        };
        push @{$obj->{$type}->{'params'}}, $item;
    }

    return $obj;
}

1;