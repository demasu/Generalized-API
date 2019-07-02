package Generic::API::Interactor::Caller;

use strict;
use warnings;

use Generic::API::Interactor::Caller::Get;
use Generic::API::Interactor::Caller::Post;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub call_out {
    my ($method, $args) = @_;
    print STDERR "# Caller.pm: In call_out\n";
    print STDERR "# Caller.pm: Method is: [$method]\n";
    print STDERR "# Caller.pm: Args is:\n";
    print STDERR "# Caller.pm: call_out: \n" . Dumper( \$args ) . "\n";

    $method = lc($method);
    if ( $method eq 'post' ) {
        print STDERR "# Caller.pm: Method was post\n";
        return Generic::API::Interactor::Caller::Post::send_request( $args );
    }
    elsif ( $method eq 'get') {
        print STDERR "# Caller.pm: Method was get\n";
        return Generic::API::Interactor::Caller::Get::send_request( $args );
    }
    else {
        print STDERR "# Caller.pm: Method was unknown\n";
        return "Method unknown";
    }
}

1;
