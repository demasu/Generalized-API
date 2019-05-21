package Generic::API::Routes::API;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';

use Generic::API;
use Generic::API::File::List;
use Generic::API::File::ReadFile;
use Generic::API::Output;

get '/api/:api/data' => sub {
    print STDERR "# Routes/API.pm: In the get '/api/:api/data' sub\n";
    if ( request->is_ajax ) {
        header( 'Content-Type' => 'application/json' );
        my $api = route_parameters->get('api');
        my $api_dir = Generic::API::get_api_dir_path();
        my $file = $api_dir . $api . '.json';

        return Generic::API::File::ReadFile::read_file($file);
    }
    else {
        send_file 'failure.html';
    }
};

get '/api/list' => sub {
    print STDERR "# Routes/API.pm: In the api/list sub\n";
    my $list = Generic::API::File::List::list_apis();
    print STDERR "# FormHandler.pm: Got the list\n";
    my $json = Generic::API::Output::encode( $list, 'json' );
    print STDERR "# FormHandler.pm: Converted to JSON\n";

    return $json;
};

1;