package Generic::API::Routes::Base;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';
use FindBin;
use JSON::MaybeXS ();

use Generic::API::Base;
use Generic::API::Form::Parse;
use Generic::API::Output;
use Generic::API::Output::JSON;
use Generic::API::Template::Variables;

get '/' => sub {
    my $links = Generic::API::Template::Variables::get_links( 'input' );

    template 'index.tt', {
        'links' => $links,
    };
};

post '/' => sub {
    my $form_data = params;
    my $api_results = Generic::API::Form::Parse::parse($form_data);
    my $links = Generic::API::Template::Variables::get_links( 'input' );

    if ( Generic::API::Base::save_api_data($api_results) ) {
        template 'success.tt', {
            'links' => $links,
        };
    }
    else {
        template 'failure.tt', {
            'links' => $links,
        };
    }
};

get '/elements' => sub {
    send_file 'elements.html';
};

start;

1;
