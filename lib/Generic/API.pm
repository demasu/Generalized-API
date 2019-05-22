package Generic::API;

use strict;
use warnings;

use Dancer2;
use FindBin;
# Get the routes

use Generic::API::Routes::API;
use Generic::API::Routes::Base;
use Generic::API::Routes::Verify;

exit __PACKAGE__->run() unless caller();

sub run {
    start;
}

1;