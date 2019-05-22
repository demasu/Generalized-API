package Generic::API::Base;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';

use Generic::API::Output::JSON;

sub get_base_path {

    return "$FindBin::Bin/../";
}

sub get_api_dir_path {
    my $base_path = get_base_path();

    return $base_path . 'apis/';
}

sub save_api_data {
    my ($data) = @_;

    my $dir  = get_api_dir_path();
    my $name = delete $data->{'api_name'};
    $name    =~ s/\s+/_/g;
    $name    =~ s/[^a-zA-Z0-9_]//g;
    $name    = lc($name);

    my $file = $dir . $name . '.json';
    if ( -e $file ) {
        # Send a message somewhere
        return 0;
    }

    return Generic::API::Output::JSON::write_to_file($file, $data);
}

1;