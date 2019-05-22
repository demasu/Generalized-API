package Generic::API::Input::JSON;

use strict;
use warnings;

use JSON::MaybeXS;

use Generic::API::File::ReadFile;

sub read_from_file {
    my ($file) = @_;

    my $json = Generic::API::File::ReadFile::read_file( $file );

    return decode(undef, $json);
}

sub decode {
    my (undef, $data ) = @_;
    # my $data = shift;
    #unless ($data) {
    #    $data = shift;
    #}
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# JSON.pm: Data sent in is:\n";
    print STDERR "# JSON.pm: encode: \n" . Dumper( \@_ ) . "\n";

    my $json = JSON::MaybeXS::decode_json($data);

    return $json;
}

1;