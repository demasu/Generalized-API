package Generic::API::File::List;

use strict;
use warnings;

use Generic::API::Base;

sub list_apis {
    my $base_path = Generic::API::Base::get_base_path();
    my $api_dir   = 'apis/';
    my $api_path  = $base_path . $api_dir;

    my @files;
    opendir( my $dir, $api_path ) or die "Unable to open directory: $!";
    while ( my $file = readdir($dir) ) {
        next if $file eq '.';
        next if $file eq '..';
        if ( -f ($api_path . $file) ) {
            push @files, $file;
        }
    }
    closedir $dir;

    return \@files;
}

1;
