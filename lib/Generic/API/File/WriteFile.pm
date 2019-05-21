package Generic::API::File::WriteFile;

use strict;
use warnings;

sub write_file {
    my ($file, $data) = @_;

    return "No data provided" unless $data;
    open( my $fh, '>', $file) or return "Problem opening file for writing: $!";
    print $fh $data;
    close $fh;

    return 1;
}

1;