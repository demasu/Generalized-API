package Generic::API::Interactor::Mock;

use strict;
use warnings;

sub mock_post {
    return sub {
        return 1;
    };
}

sub mock_get {
    return sub {
        return 1;
    };
}

1;
