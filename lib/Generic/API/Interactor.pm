package Generic::API::Interactor;

use strict;
use warnings;

use Generic::API::Interactor::Caller;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub new {
    my ($class, $config) = @_;
    print STDERR "# Interactor.pm: In the new subroutine\n";

    my $self = {};

    $self->{base_url}     = delete $config->{base_url};
    $self->{username}     = delete $config->{username};
    $self->{password}     = delete $config->{password};
    $self->{query_method} = delete $config->{query_method};
    $self->{calls}        = $config;

    print STDERR "# Interactor.pm: Self is:\n";
    print STDERR "# Interactor.pm: new: \n" . Dumper( \$self ) . "\n";

    return bless($self, $class);
}

sub generic_call {
    my ($self, $call, $params) = @_;

    if ( $self->{calls}->{$call} ) {
        my $args = {
            call   => $self->{calls}->{$call},
            url    => $self->{base_url},
            params => $params,
        };
        my $return = Generic::API::Interactor::Caller::call_out( $self->{query_method}, $args );
        return $return;
    }
    else {
        return _error_message($call);
    }
}

sub order {
    my ($self, $params) = @_;

    if ( $self->{calls}->{order} ) {
        my $args = {
            call   => 'order',
            url    => $self->{base_url},
            params => $params,
        };
        my $return = Generic::API::Interactor::Caller::call_out( $self->{query_method}, $args );
        return $return;
    }
    else {
        return _error_message('order');
    }
}

sub _error_message {
    my ($call) = @_;

    return "Specified call, '" . $call . "', not known";
}

1;

__END__

Structure of things passed in:
{
    "base_url": "https://example.tld",
    "cancel": {
        "call": "cancel",
        "params": [
            {
                "name": "item_type",
                "required": null
            },
            {
                "name": "item_serial",
                "required": "on"
            },
            {
                "name": "domain",
                "required": null
            },
            {
                "name": "ip_address",
                "required": null
            }
        ]
    },
    "order": {
        "call": "order",
        "params": [
            {
                "name": "quantity",
                "required": "on"
            },
            {
                "name": "domain",
                "required": null
            },
            {
                "name": "ip_address",
                "required": null
            },
            {
                "name": "type",
                "required": "on"
            }
        ]
    },
    "password": "password",
    "query_method": "post",
    "username": "username"
}