package Generic::API::Interactor::Caller::Send;

use strict;
use warnings;

use Generic::API::Interactor::Mock;

use Test::MockModule; # Since we don't want to actually send out with this proof of concept
my $mlwp = Test::MockModule->new('LWP::UserAgent');

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub setup {
    #$mlwp->mock( 'post' => Generic::API::Interactor::Mock::mock_post() );
    #$mlwp->mock( 'get'  => Generic::API::Interactor::Mock::mock_get()  );
    #$mlwp->mock( 'is_success' => Generic::API::Interactor::Mock::mock_is_success() );
    #$mlwp->mock( 'decoded_content' => Generic::API::Interactor::Mock::mock_decoded_content() );
    #$mlwp->mock( 'status_line' => Generic::API::Interactor::Mock::mock_status_line() );
    my $ua = LWP::UserAgent->new(timeout => 10);
    $ua->agent('Mozilla/5.0');

    return $ua;
}

sub send_request {
    my ($method, $request) = @_;
    print STDERR "# Send.pm: In send_request\n";
    print STDERR "# Send.pm: Method is: [$method]\n";
    print STDERR "# Send.pm: Request is:\n";
    print STDERR "# Send.pm: send_request: \n" . Dumper( \$request ) . "\n";

    print STDERR "# Send.pm: Calling setup\n";
    my $ua = setup();
    print STDERR "# Send.pm: LWP is set up\n";

    my %verbs = (
        post => \&post,
        get  => \&get,
    );

    $request->{url} = 'https://astudyinfutility.com/api/';
    my $url = $request->{url} . $request->{method};
    print STDERR "# Send.pm: Url is: [$url]\n";

    print STDERR "# Send.pm: Calling the API\n";
    my $response = $verbs{$method}->( $ua, $url, $request->{data} );
    if ( $response->is_success ) {
        print STDERR "# Send.pm: Response was a success\n";
        return $response->decoded_content;
    }
    else {
        print STDERR "# Send.pm: Response was not a success\n";
        print STDERR "# Send.pm: Content is:\n";
        print STDERR "# Send.pm: send_request: \n" . Dumper( \$response->content ) . "\n";
        return "There was an error communicating with the endpoint. " . $response->status_line;
    }
}

sub post {
    my ($ua, $url, $data) = @_;
    print STDERR "# Send.pm: In the post sub\n";
    print STDERR "# Send.pm: URL is: [$url]\n";
    print STDERR "# Send.pm: Data is:\n";
    print STDERR "# Send.pm: post: \n" . Dumper( \$data ) . "\n";
    print STDERR "# Send.pm: User agent is:\n";
    print STDERR "# Send.pm: post: \n" . Dumper( \$ua ) . "\n";

    print STDERR "# Send.pm: Returning the result of the post\n";
    return $ua->post( $url, $data );
}

sub get {
    my ($ua, $url, $data) = @_;

    return $ua->get( $url, $data );
}

1;
