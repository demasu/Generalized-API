package Generic::API::Routes::Verify;

use strict;
use warnings;

use Dancer2 appname => 'Generic::API';

use Generic::API::File::ReadFile;

get '/verify' => sub {
    print STDERR "# Routes/Verify.pm: In the get '/verify' sub\n";

    send_file 'verify.html';
};

post '/verify' => sub {
    my $data = params;
    my $file = $data->{'api'};
    my $contents = Generic::API::File::ReadFile::read_file($file);

    return $contents;
};

1;