package Generic::API::Builder;

use strict;
use warnings;

use Generic::API::Input::JSON;
use Generic::API::Interactor;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub new {
    my ($class, $args) = @_;
    $args = {}; # No idea what args I want

    return bless($args, $class);
}

sub build {
    my ($self, $api_name) = @_;

    my $obj = Generic::API::Input::JSON::read_from_file( $api_name );

    print STDERR "# Builder.pm: Object is:\n";
    print STDERR "# Builder.pm: build: \n" . Dumper( \$obj ) . "\n";

    return Generic::API::Interactor->new($obj);
}

1;