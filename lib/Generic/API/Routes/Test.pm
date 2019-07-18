package Generic::API::Routes::Test;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';
use FindBin;

use Generic::API::Interactor::Base;
use Generic::API::Output;
use Generic::API::Template::Variables;

get '/test' => sub {
    my $links = Generic::API::Template::Variables::get_links( 'test' );
    template 'test.tt', {
        'links' => $links,
        'custom_js' => [
            {
                src => 'assets/js/test/test.min.js',
            },
        ],
    };
};

post '/test' => sub {
    my $form_data = params;

    my $interactor = Generic::API::Interactor::Base->new( $form_data );
    my $data       = $interactor->load_api();
    my $result     = $interactor->perform_call();

    return $result;
};

post '/test/functions' => sub {
    my $data = params;

    my $interactor = Generic::API::Interactor::Base->new( $data );
    my $functions  = $interactor->get_func_list();

    my $json = Generic::API::Output::encode( $functions, 'json' );

    return $json;
};

post '/test/parameters' => sub {
    my $data = params;

    my $interactor = Generic::API::Interactor::Base->new( $data );
    my $parameters = $interactor->get_param_list();

    my $json = Generic::API::Output::encode( $parameters, 'json' );

    return $json;
};

1;
