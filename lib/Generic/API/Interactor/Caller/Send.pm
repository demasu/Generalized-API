package Generic::API::Interactor::Caller::Send;

use strict;
use warnings;

use LWP::UserAgent;

sub setup {
    my $ua = LWP::UserAgent->new(timeout => 10);

    return $ua;
}

sub send_request {
    my ($method, $request) = @_;

    my $ua = setup();

    my %verbs = (
        post => \&post,
        get  => \&get,
    );

    my $response = $verbs{$method}->( $ua, $request->{url}, $request->{data} );
    if ( $response->is_success ) {
        return $response->decoded_content;
    }
    else {
        return "There was an error communicating with the endpoint. " . $response->status_line;
    }
}

sub post {
    my ($ua, $url, $data) = @_;

    return $ua->post( $url, $data );
}

sub get {
    my ($ua, $url, $data) = @_;

    return $ua->get( $url, $data );
}

1;