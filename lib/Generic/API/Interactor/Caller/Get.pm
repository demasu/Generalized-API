package Generic::API::Interactor::Caller::Post;

use strict;
use warnings;

use Generic::API::Interactor::Caller::Send;

sub send_request {
    my ($args) = @_;

    # Format stuff
    # url = base_url + call
    # data = {
    #     field => value,
    #     field => value,
    # }
    my $request;

    return Generic::API::Interactor::Caller::Send::send_request( 'get', $request );
}

1;