package Generic::API::Input;

use strict;
use warnings;

my %decoders = (
    'JSON' => 'Generic::API::Input::JSON',
);

sub decode {
    my ($data, $type) = @_;

    $type = uc($type);
    my $return;
    if ( $decoders{$type} ) {
        $return = $decoders{$type}->decode($data);
    }
    else {
        $return = "No decoders found for type $type";
    }
}

1;