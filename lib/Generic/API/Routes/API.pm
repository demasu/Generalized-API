package Generic::API::Routes::API;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';

use Generic::API::Base;
use Generic::API::File::List;
use Generic::API::File::ReadFile;
use Generic::API::Output;
use Generic::API::Template::Variables;

get '/api/:api/data' => sub {
    if ( request->is_ajax ) {
        header( 'Content-Type' => 'application/json' );
        my $api = route_parameters->get('api');
        my $api_dir = Generic::API::Base::get_api_dir_path();
        my $file = $api_dir . $api . '.json';

        return Generic::API::File::ReadFile::read_file($file);
    }
    else {
        my $links = Generic::API::Template::Variables::get_links( 'api' );

        template 'failure.tt', {
            'links' => $links,
        };
    }
};

get '/api/list' => sub {
    my $list = Generic::API::File::List::list_apis();
    my $json = Generic::API::Output::encode( $list, 'json' );

    return $json;
};

1;
