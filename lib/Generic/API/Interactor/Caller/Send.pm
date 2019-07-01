package Generic::API::Interactor::Caller::Send;

use strict;
use warnings;

use Generic::API::Interactor::Mock;

use Test::MockModule; # Since we don't want to actually send out with this proof of concept
my $mlwp = Test::MockModule->new('LWP::UserAgent');
$mlwp->mock( 'post' => Generic::API::Interactor::Mock::mock_post() );
$mlwp->mock( 'get'  => Generic::API::Interactor::Mock::mock_get()  );

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

    print STDERR "# Send.pm: Url is: [" . $request->{url} . "]\n";
    print STDERR "# Send.pm: Data is: [" . $request->{data} . "]\n";
    #my $response = $verbs{$method}->( $ua, $request->{url}, $request->{data} );
    #if ( $response->is_success ) {
    #    return $response->decoded_content;
    #}
    #else {
    #    return "There was an error communicating with the endpoint. " . $response->status_line;
    #}
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
