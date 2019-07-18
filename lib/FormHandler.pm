package FormHandler;

use strict;
use warnings;

use Dancer2;
use FindBin;
use JSON::MaybeXS ();

use Data::Dumper;
$Data::Dumper::Indent = 3;

get '/' => sub {
    send_file 'index.html';
};

post '/' => sub {
    my $stuff = params;

    my $api_results = parse_form($stuff);

    if ( write_to_json($api_results) ) {
        send_file 'success.html';
    }
    else {
        send_file 'failure.html';
    }

};

get '/verify' => sub {

    send_file 'verify.html';
};

post '/verify' => sub {
    my $stuff = params;
    my $file = $stuff->{'api'};
    my $data = read_from_file($file);
    return $data;
};

get '/api/:api/data' => sub {
    if ( request->is_ajax ) {
        header( 'Content-Type' => 'application/json' );
        my $api = route_parameters->get('api');
        my $dir = "$FindBin::Bin/../apis/";
        my $file = $dir . $api . '.json';

        open( my $fh, "<", $file ) or die "Unable to open file: $!";
        my $json = <$fh>;
        close $fh;

        return $json;
    }
    else {
        send_file 'failure.html';
    }
};

get '/api/list' => sub {
    my $list = get_api_list();
    my $json = JSON::MaybeXS::encode_json($list);

    return $json;
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
    $name =~ s/\s+/_/g;
    $name =~ s/[^a-zA-Z0-9_]//g;
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

    return 1;
}

sub get_api_list {
    my $path = "$FindBin::Bin/../apis/";

    my @files;
    opendir( my $dir, $path ) or die "Unable to open directory: $!";
    while ( my $file = readdir($dir) ) {
        next if $file eq '.';
        next if $file eq '..';
        if ( -f ($path . $file) ) {
            push @files, $file;
        }
    }
    closedir $dir;

    return \@files;
}

sub read_from_file {
    my $file = shift;
    my $path = "$FindBin::Bin/../apis/";
    my $full_path = $path . $file;

    if ( -f $full_path ) {
        open( my $fh, "<", $full_path ) or die "Unable to open file: $!";
        my $json = <$fh>;
        close $fh;
        return $json;
    }
    else {
        return "Unable to locate file.";
    }
}

1;
