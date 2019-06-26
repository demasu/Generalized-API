package Generic::API::Routes::Test;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';
use FindBin;

use Generic::API::Template::Variables;

get '/test' => sub {
    my $links = Generic::API::Template::Variables::get_links( 'test' );
    template 'test.tt', {
        'links' => $links,
        'custom_js' => [
            {
                src => 'assets/js/test/test.js',
            },
        ],
    };
};

1;
