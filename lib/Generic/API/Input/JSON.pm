package Generic::API::Input::JSON;

use strict;
use warnings;

use JSON::MaybeXS;

use Generic::API::File::ReadFile;

sub read_from_file {
    my ($file) = @_;

    my $json = Generic::API::File::ReadFile::read_file( $file );

    return decode($json);
}

sub decode {
    my ($data) = @_;

    my $json = JSON::MaybeXS::decode_json($data);

    return $json;
}

1;
