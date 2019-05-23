package Generic::API::Validator;

use strict;
use warnings;

sub new {
    my ($class) = @_;

    # Every api needs to have the following:
    # base_url
    # username
    # password
    # query_method

    # Everything else is a parameter.

    # Required parameters:
    # order
    # cancel

    # Parameters can have required options which must then have data.

    my $errors = {              # Let's be nice to the user and collect all errors at once
        base_url => 0,
        username => 0,
        password => 0,
        query_method => 0,
        parameters => [
            order => {
                parameters => [
                    name => 0,  # Will be 1 if required and not set. If optional, will always be 0
                ],
            },
            cancel => {
                parameters => [
                    name => 0,
                ],
            },
        ],
    };

    my $self = {
        has_errors => 0,
        errors     => $errors,
        data       => '',
    };
    bless( $self, $class );

    return $self;
}

sub validate {
    my ($self, $data) = @_;

    unless ( ref($self) eq 'Generic::API::Validator' ) {
        $data = $self;
        $self = __PACKAGE__->new();
    }

    $self->_check_base_values();
    $self->_check_required_parameters();
    $self->_check_other_parameters();

    if ( $self->{has_errors} ) {
        return $self->_report_errors();
    }

    return;
}

sub _check_base_values {
    my ($self) = @_;

}

sub _check_required_parameters {
    my ($self) = @_;

}

sub _check_other_parameters {
    my ($self) = @_;

}

sub _report_errors {
    my ($self) = @_;

}

1;