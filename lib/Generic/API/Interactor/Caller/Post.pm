package Generic::API::Interactor::Caller::Post;

use strict;
use warnings;

use Generic::API::Interactor::Caller::Send;

sub send_request {
    my ($args) = @_;
    my $request;

    my $api_data = $args->{'api_data'};
    my $method   = $args->{'method'};
    my $values   = $args->{'params'};

    my $base_url  = $api_data->{'base_url'};
    my $post_data = {};

    if ( !exists $api_data->{$method} ) {
        die "The provided method ('$method') does not exist in the API specification.\n";
    }
    foreach my $param ( @{$api_data->{$method}->{'params'}} ) {
        if ( $param->{'required'} ) {
            # Parameter is required
            if ( $values->{$param->{name}} ) {
                # Parameter has data
                $post_data->{$param->{name}} = $values->{$param->{name}};
            }
            else {
                # Parameter has no data
                die "The parameter [" . $param->{name} . "] is required, but came with no value.\n";
            }
        }
        elsif ( $values->{$param->{name}} ) {
            # Parameter is optional, but has data
            $post_data->{$param->{name}} = $values->{$param->{name}};
        }
        else {
            # Default just to see what hits it
        }
    }

    $request->{url}  = $api_data->{'base_url'};
    $request->{data} = $post_data;
    $request->{method} = $method;

    return Generic::API::Interactor::Caller::Send::send_request( 'post', $request );
}

1;
