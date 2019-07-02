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

    print STDERR "# Post.pm: Values is:\n";
    print STDERR "# Post.pm: send_request: \n" . Dumper( \$values ) . "\n";

    if ( !exists $api_data->{$method} ) {
        die "The provided method ('$method') does not exist in the API specification.\n";
    }
    print STDERR "# Post.pm: Iterating over params\n";
    foreach my $param ( @{$api_data->{$method}->{'params'}} ) {
        print STDERR "# Post.pm: Checking if param [$param->{name}] is required\n";
        if ( $param->{'required'} ) {
            # Parameter is required
            print STDERR "# Post.pm: Param is required\n";
            if ( $values->{$param->{name}} ) {
                # Parameter has data
                print STDERR "# Post.pm: Required value seems to be there:\n";
                $post_data->{$param->{name}} = $values->{$param->{name}};
            }
            else {
                # Parameter has no data
                die "The parameter [" . $param->{name} . "] is required, but came with no value.\n";
            }
        }
        elsif ( $values->{$param->{name}} ) {
            # Parameter is optional, but has data
            print STDERR "# Post.pm: Adding optional parameter [" . $param->{name} . "] to data\n";
            $post_data->{$param->{name}} = $values->{$param->{name}};
        }
        else {
            # Default just to see what hits it
            print STDERR "# Post.pm: Param is not required\n";
        }
    }

    print STDERR "# Post.pm: Post data is:\n";
    print STDERR "# Post.pm: send_request: \n" . Dumper( \$post_data ) . "\n";

    $request->{url}  = $api_data->{'base_url'};
    $request->{data} = $post_data;
    $request->{method} = $method;

    print STDERR "# Post.pm: Sending the request\n";
    return Generic::API::Interactor::Caller::Send::send_request( 'post', $request );
}

1;
