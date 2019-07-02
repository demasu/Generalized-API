package Generic::API::Interactor::Mock;

use strict;
use warnings;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub mock_post {
    return sub {
        my ($self, $url, $data) = @_;
        print STDERR "# Mock.pm: In the mocked post sub\n";
        print STDERR "# Mock.pm: Arguments sent in are:\n";
        return $self;
    };
}

sub mock_get {
    return sub {
        my ($self, $url, $data) = @_;
        print STDERR "# Mock.pm: In the mocked get sub\n";
        return $self;
    };
}

sub mock_is_success {
    return sub {
        print STDERR "# Mock.pm: In the mocked is_success sub\n";
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
