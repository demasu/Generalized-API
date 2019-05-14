package FormHandler;

use strict;
use warnings;

use Dancer2;
use FindBin;
use JSON::MaybeXS ();

use Data::Dumper;
$Data::Dumper::Indent = 3;

get '/' => sub {
    print STDERR "# FormHandler.pm: In the get '/' sub\n";

    send_file 'index.html';
};

post '/' => sub {
    print STDERR "# FormHandler.pm: In the post '/' sub\n";
    my $stuff = params;
    print STDERR "# form_handler.pl: \n" . Dumper( \$stuff ) . "\n";

    my $api_results = parse_form($stuff);
    print STDERR "# FormHandler.pm: \n" . Dumper( \$api_results ) . "\n";

    write_to_json($api_results);

    send_file 'success.html';

};

get '/verify' => sub {
    print STDERR "# FormHandler.pm: In the get '/verify' sub\n";

    send_file 'verify.html';
};

start;


sub parse_form {
    my ($data) = @_;

    my %obj;

    $obj{'api_name'} = $data->{'api-name'};
    $obj{'base_url'} = $data->{'base-url'};
    $obj{'query_method'} = $data->{'query-method'};
    $obj{'username'} = $data->{'username'};
    $obj{'password'} = $data->{'password'};
    $obj{'order'} = {
        'call' => $data->{'order-call'},
        'params' => [],
    };
    $obj{'cancel'} = {
        'call' => $data->{'cancel-call'},
        'params' => [],
    };

    my @order_params  = grep { $_ =~ /^order-param-/  } keys(%{$data});
    my @cancel_params = grep { $_ =~ /^cancel-param-/ } keys(%{$data});

    foreach my $param ( @order_params ) {
        my $required = 'required-' . $param;
        my $item = {
            'name' => $data->{$param},
            'required' => $data->{$required},
        };
        push @{$obj{'order'}{'params'}}, $item;
    }

    foreach my $param ( @cancel_params ) {
        my $required = 'required-' . $param;
        my $item = {
            'name' => $data->{$param},
            'required' => $data->{$required},
        };
        push @{$obj{'cancel'}{'params'}}, $item;
    }

    return \%obj;
}

sub write_to_json {
    my ($data) = @_;

    my $dir  = "$FindBin::Bin/../apis/";
    my $name = delete $data->{'api_name'};
    $name =~ s/[^a-zA-Z0-9]//g;
    $name = lc($name);

    my $file = $dir . $name . '.json';
    if ( -e $file ) {
        # Send a message somewhere
        return 0;
    }

    my $json = JSON::MaybeXS::encode_json($data);

    open( my $fh, ">", $file ) or die "Unable to open file: $!";
    print $fh $json;
    close $fh;

    return;
}

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