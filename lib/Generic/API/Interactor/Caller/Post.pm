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
            #if ( $values)
        }
    }

    return Generic::API::Interactor::Caller::Send::send_request( 'post', $request );
}

1;
