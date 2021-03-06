package Generic::API::Output::JSON;

use strict;
use warnings;

use JSON::MaybeXS;

use Generic::API::File::ReadFile;
use Generic::API::Output::File::WriteFile;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub write_to_file {
    my ($file, $data) = @_;

    print STDERR "# Output/JSON.pm: Data is:\n";
    print STDERR "# Output/JSON.pm: write_to_file: \n" . Dumper( \$data ) . "\n";
    my $json = JSON::MaybeXS::encode_json($data);
    print STDERR "# Output/JSON.pm: Data is now:\n";
    print STDERR "# Output/JSON.pm: write_to_file: \n" . Dumper( \$json ) . "\n";
    my $return = Generic::API::Output::File::WriteFile::write_file( $file, $json );

    return $return;
}

sub encode {
    my (undef, $data ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# Output/JSON.pm: Data sent in is:\n";
    print STDERR "# Output/JSON.pm: encode: \n" . Dumper( \@_ ) . "\n";

    my $json = JSON::MaybeXS::encode_json($data);

    return $json;
}

1;
