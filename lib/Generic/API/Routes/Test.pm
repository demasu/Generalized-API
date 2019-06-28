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
                src => 'assets/js/test/test.js',
            },
        ],
    };
};

post '/test' => sub {
    # Get data from specified file
    # Load data
    # Hand off to modules to do stuff
    my $form_data = params;
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# Test.pm: Form data is:\n";
    print STDERR "# Test.pm: post '/test': \n" . Dumper( \$form_data ) . "\n";

    my $interactor = Generic::API::Interactor::Base->new( $form_data );
    my $data       = $interactor->load_api();

    return 'Success!'; # ¯\_(ツ)_/¯
};

post '/test/functions' => sub {
    my $data = params;
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# Test.pm: Data is:\n";
    print STDERR "# Test.pm: get '/test/functions': \n" . Dumper( \$data ) . "\n";

    my $interactor = Generic::API::Interactor::Base->new( $data );
    my $functions  = $interactor->get_func_list();
    print STDERR "# Test.pm: Functions are:\n";
    print STDERR "# Test.pm: get '/test/functions': \n" . Dumper( \$functions ) . "\n";

    my $json = Generic::API::Output::encode( $functions, 'json' );

    return $json;
};

1;

__END__
Data we get from the page when submitting the form:

# Test.pm: Form data is:
# Test.pm: post '/test':
$VAR1 = \{
            'function' => '4',
            'func-value' => 'asdf',
            'api' => 'whats_this.json'
          };
