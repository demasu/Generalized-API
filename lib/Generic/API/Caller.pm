package Generic::API::Caller;

use strict;
use warnings;

sub new {
    my ($class, $args) = @_;
    $args = {}; # Don't know what options I want to have, if any yet

    return bless($args, $class);
}

sub verify {
    my ($self, $api_name, $thing) = @_;
}

1;