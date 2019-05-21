package Generic::API::Output;

use strict;
use warnings;

use Module::Pluggable search_dirs => ['Output'], max_depth => 4;

my %encoders = (
    'JSON' => 'Generic::API::Output::JSON',
);

sub output {
    my $args = shift;

    my $data   = delete $args->{data};
    my $format = delete $args->{format};

}

sub write {
    
}

sub encode {
    my ($data, $type) = @_;

    $type = uc($type);
    my $return;
    if ( $encoders{$type} ) {
        $return = $encoders{$type}->encode($data);
    }
    else {
        $return = "No encoders found for type $type";
    }
}

1;