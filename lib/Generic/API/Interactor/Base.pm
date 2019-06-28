package Generic::API::Interactor::Base;

use strict;
use warnings;

use Generic::API::File::ReadFile;

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
    print STDERR "# Base.pm: Data is:\n";
    print STDERR "# Base.pm: load_api: \n" . Dumper( \$data ) . "\n";

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

sub _validate_args {
    my $args = shift;

    #my @required = qw( function func-value api );
    my @required = qw( api );
    my $error    = 0;
    my @message;

    my %missing = (
        'missing_params' => [],
        'missing_values' => [],
    );
    foreach my $req ( @required ) {
        if ( !exists $args->{$req} ) {
            push @{$missing{'missing_params'}}, $req;
        }
        elsif ( !length $args->{$req} || $args->{$req} eq '' ) {
            push @{$missing{'missing_values'}}, $req;
        }
    }

    my $missing_param_count = scalar( @{ $missing{'missing_params'} } );
    my $missing_value_count = scalar( @{ $missing{'missing_values'} } );
    if ( $missing_param_count ) {
        my $string = q{The parameter%s %s %s required.}; # The parameter(s) one, two are/is required.
        my $params = _format_array_as_string( $missing{'missing_params'}, ',', 1 );
        $string = sprintf( $string, ($missing_param_count > 1 ? 's' : ''),
                                    $params,
                                    ($missing_param_count > 1 ? 'are' : 'is')
        );
        push @message, $string;
    }
    if ( $missing_value_count ) {
        my $string = q{The parameter%s %s cannot be empty.}; # The parameter(s) one, two cannot be empty.
        my $params = _format_array_as_string( $missing{'missing_values'}, ',', 1 );
        $string = sprintf( $string, ($missing_value_count > 1 ? 's' : ''), $params );

        push @message, $string;
    }

    if ( scalar(@message) ) {
        my $message = "The following errors were reported:\n";
        $message .= join( "\n", @message );
        die $message;
    }

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
