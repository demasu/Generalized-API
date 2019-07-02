package Generic::API::Interactor::Base;

use strict;
use warnings;

use Generic::API::Input::JSON;
use Generic::API::Interactor::Caller;
use Generic::API::File::ReadFile;

use Params::Validate;

use Data::Dumper;
$Data::Dumper::Indent = 3;

sub new {
    my ($package, $args) = @_;

    my $self;

    if ( $args ) {
        _validate_args($args);
        $self = $args;
    }
    else {
        $self = {};
    }

    return bless($self, $package);
}

sub load_api {
    my ($self) = @_;

    my $data = Generic::API::File::ReadFile::read_file( $self->{'api'} );
    $data    = Generic::API::Input::JSON::decode($data);
    $self->{'api_data'} = $data;

    return $data;
}

sub get_func_list {
    my ($self) = @_;

    my $data = $self->load_api();
    my @ignores = qw( username password base_url query_method );
    my @functions;
    foreach my $key ( keys( %{$data} ) ) {
        if ( grep { $_ =~ $key } @ignores ) {
            next;
        }
        push @functions, $key;
    }

    return \@functions;
}

sub get_param_list {
    my ($self) = @_;

    my $data = $self->load_api();
    my @ignores    = qw( username password base_url query_method );
    my @parameters;

    foreach my $param ( @{ $data->{ $self->{'function'} }->{'params'} } ) {
        push @parameters, $param;
    }

    print STDERR "# Base.pm: parameters are:\n";
    print STDERR "# Base.pm: get_param_list: \n" . Dumper( \@parameters ) . "\n";

    return \@parameters;
}

sub perform_call {
    my ($self) = @_;

    die "Please specify a function" unless $self->{'function'};

    my $call_type = $self->{'api_data'}->{'query_method'};
    my $args      = {
        method   => $self->{'function'},
        params   => {},
        api_data => delete $self->{'api_data'},
    };
    my @values = grep { $_ =~ /value-for-/ } keys( %{$self} );
    foreach my $val ( @values ) {
        if ( $val =~ /value-for-(.+)/ ) {
            $args->{params}->{$1} = $self->{$val};
        }
    }
    print STDERR "# Base.pm: Args is:\n";
    print STDERR "# Base.pm: perform_call: \n" . Dumper( \$args ) . "\n";
    my $result    = Generic::API::Interactor::Caller::call_out( $call_type, $args );

    if ( $result eq 'Method unknown' ) {
        die "Unknown API Query Method: [" . $call_type . "]\n";
    }

    return $result;
}

sub _validate_args {
    my $args = shift;

    Params::Validate::validate_with(
        'params' => $args,
        'spec'   => {
            'api' => {
                'type'     => Params::Validate::SCALAR,
                'regex'    => qr/^\w+\.json$/,
                'optional' => 0,
            },
            'function' => {
                'type'     => Params::Validate::SCALAR,
                'regex'    => qr/^.+$/,
                'optional' => 1,
            },
            'func-value' => {
                'type'     => Params::Validate::SCALAR,
                'regex'    => qr/^.+$/,
                'optional' => 1,
                'depends'  => [ 'function' ],
            },
        },
        'on_fail' => sub {
            my $message = shift;
            $message =~ s/Generic::API::Interactor::Base::_validate_args//;
            $message =~ s/\s+in\s+call\s+to\s+$//;
            $message =~ s/\s+to\s+(did)/ $1/;
            die "$message\n";
        },
        'allow_extra' => 1,
    );

    return 1;
}

sub _format_array_as_string {
    my ($array, $joiner, $quoted) = @_;
    my @data = @{$array};

    my $length = scalar( @data );
    my $string = '';
    my $count  = 1;
    foreach my $item ( @data ) {
        $string .= q{'} if $quoted;
        $string .= $item;
        $string .= q{'} if $quoted;
        if ( $count < $length ) {
            $string .= $joiner;
            $string .= q{ };
        }
        else {
            # Last iteration, don't print joiner or space
        }
        $count++;
    }

    return $string;
}

1;
