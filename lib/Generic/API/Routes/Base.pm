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

use Data::Dumper;
$Data::Dumper::Indent = 3;

get '/' => sub {
    print STDERR "# Routes/Base.pm: In the get '/' sub\n";

    send_file 'index.html';
};

post '/' => sub {
    print STDERR "# Routes/Base.pm: In the post '/' sub\n";
    my $form_data = params;
    print STDERR "# Routes/Base.pm: \n" . Dumper( \$form_data ) . "\n";

    my $api_results = Generic::API::Form::Parse::parse($form_data);
    print STDERR "# Routes/Base.pm: \n" . Dumper( \$api_results ) . "\n";

    if ( Generic::API::Base::save_api_data($api_results) ) {
        send_file 'success.html';
    }
    else {
        send_file 'failure.html';
    }
};

start;

1;

__END__

Structure of the params return:
{
    'base-url' => 'https://example.tld',
    'query-method' => 'post',
    'order-param-2' => 'asdf',
    'order-call' => 'asdf',
    'username' => 'asdfa',
    'cancel-param-2' => 'asdf',
    'required-order-param-1' => 'on',
    'cancel-call' => 'as',
    'password' => 'asdfasdf',
    'cancel-param-1' => 'asdf',
    'order-param-1' => 'asdf',
    'required-cancel-param-2' => 'on',
    'query-type' => 'form'
};