package Generic::API;

use strict;
use warnings;

use Dancer2;
use FindBin;
# Get the routes

use Generic::API::Routes::API;
use Generic::API::Routes::Base;
use Generic::API::Routes::Verify;
use Generic::API::Routes::Test;

prefix '/fancy';
set template => 'template_toolkit';

exit __PACKAGE__->run() unless caller();

sub run {
    start;
}

1;
