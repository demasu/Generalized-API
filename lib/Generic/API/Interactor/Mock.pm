package Generic::API::Interactor::Mock;

use strict;
use warnings;

sub mock_post {
    return sub {
        my ($self, $url, $data) = @_;
        return $self;
    };
}

sub mock_get {
    return sub {
        my ($self, $url, $data) = @_;
        return $self;
    };
}

sub mock_is_success {
    return sub {
        return 1;
    };
}

sub mock_decoded_content {
    return sub {
        my $content = {
            'data' => 'blahblahblah',
        };
        return $content;
    };
}

sub mock_status_line {
    return sub {
        return '404';
    };
}

1;
