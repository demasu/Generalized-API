package Generic::API::Interactor::Caller::Post;

use strict;
use warnings;

use Generic::API::Interactor::Caller::Send;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub send_request {
    my ($args) = @_;
    my $request;
    print STDERR "# Post.pm: Args sent in is:\n";
    print STDERR "# Post.pm: send_request: \n" . Dumper( \$args ) . "\n";

    my $api_data = $args->{'api_data'};
    my $method   = $args->{'method'};
    my $values   = $args->{'params'};

    my $base_url  = $api_data->{'base_url'};
    my $post_data = {};

    if ( !exists $api_data->{$method} ) {
        die "The provided method ('$method') does not exist in the API specification.\n";
    }
    print STDERR "# Post.pm: Iterating over params\n";
    foreach my $param ( @{$api_data->{$method}->{'params'}} ) {
        print STDERR "# Post.pm: Checking if param is required\n";
        if ( $param->{'required'} ) {
            print STDERR "# Post.pm: Param is required\n";
            #if ( $values)
        }
    }

    print STDERR "# Post.pm: Sending the request\n";
    return Generic::API::Interactor::Caller::Send::send_request( 'post', $request );
}

1;
