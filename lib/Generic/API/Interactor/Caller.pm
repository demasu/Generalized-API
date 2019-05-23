package Generic::API::Interactor::Caller;

use strict;
use warnings;

use Generic::API::Interactor::Caller::Get;
use Generic::API::Interactor::Caller::Post;

sub call_out {
    my ($method, $args) = @_;

    $method = lc($method);
    if ( $method eq 'post' ) {
        Generic::API::Interactor::Caller::Post::send_request( $args );
    }
    elsif ( $method eq 'get') {
        Generic::API::Interactor::Caller::Get::send_request( $args );
    }
    else {
        return "Method unknown";
    }
}

1;
