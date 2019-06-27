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

post '/test' => sub {
    # Get data from specified file
    # Load data
    # Hand off to modules to do stuff
    my $form_data = params;
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# Test.pm: Form data is:\n";
    print STDERR "# Test.pm: post '/test': \n" . Dumper( \$form_data ) . "\n";
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
