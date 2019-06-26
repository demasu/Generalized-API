package Generic::API::Routes::Verify;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';

use Generic::API::File::ReadFile;
use Generic::API::Template::Variables;

get '/verify' => sub {
    print STDERR "# Routes/Verify.pm: In the get '/verify' sub\n";

    my $links = Generic::API::Template::Variables::get_links( 'verify' );
    template 'verify.tt', {
        'links' => $links,
        'custom_js' => [
            {
                src => 'assets/js/verify/verify.js',
            }
        ],
    };
};

post '/verify' => sub {
    my $data = params;
    my $file = $data->{'api'};
    my $contents = Generic::API::File::ReadFile::read_file($file);

    return $contents;
};

1;
