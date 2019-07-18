package Generic::API::Output::JSON;

use strict;
use warnings;

use JSON::MaybeXS;

use Generic::API::File::ReadFile;
use Generic::API::Output::File::WriteFile;

sub write_to_file {
    my ($file, $data) = @_;

    my $json = JSON::MaybeXS::encode_json($data);
    my $return = Generic::API::Output::File::WriteFile::write_file( $file, $json );

    return $return;
}

sub encode {
    my (undef, $data ) = @_;

    my $json = JSON::MaybeXS::encode_json($data);

    return $json;
}

1;
