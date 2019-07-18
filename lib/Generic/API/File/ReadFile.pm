package Generic::API::File::ReadFile;

use strict;
use warnings;

use Generic::API::Base;
use JSON::MaybeXS;

sub read_file {
    my $file = shift;

    if ( !-f $file ) {
        my $dir = _search_dirs($file);
        if ( $dir ) {
            $file = $dir . $file;
        }
        else {
            return "File does not exist.";
        }
    }

    open( my $fh, '<', $file ) or return "There was a problem opening the file: $!";
    my $json = do {
        local $/;
        <$fh>;
    };
    close $fh;

    my $data = $json;

    return $data;
}

sub _search_dirs {
    my $file = shift;
    my @dirs = ( Generic::API::Base::get_base_path(), Generic::API::Base::get_api_dir_path() );

    foreach my $dir ( @dirs ) {
        my $full_path = $dir . $file;
        if ( -f $full_path ) {
            return $dir;
        }
    }

    return;
}

1;
