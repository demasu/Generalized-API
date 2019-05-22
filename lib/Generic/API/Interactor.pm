package Generic::API::Interactor;

use strict;
use warnings;

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

sub call {
    my ($self, $call, $args) = @_;

    if ( $self->{calls}->{$call} ) {
        my $return = Generic::API::Interactor::Caller::call_out( $self->{query_method}, $self->{calls}->{$call}, $args );
        return $return;
    }
    else {
        return "Specified call, '$call', not known";
    }
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