package Generic::API::File::List;

use strict;
use warnings;

use Generic::API::Base;

sub list_apis {
    my $base_path = Generic::API::Base::get_base_path();
    my $api_dir   = 'apis/';
    my $api_path  = $base_path . $api_dir;

    my @files;
    use Data::Dumper;
    $Data::Dumper::Indent = 3;
    print STDERR "# List.pm: API Path is:\n";
    print STDERR "# List.pm: list_apis: \n" . Dumper( \$api_path ) . "\n";
    print STDERR "# List.pm: Base path is:\n";
    print STDERR "# List.pm: list_apis: \n" . Dumper( \$base_path ) . "\n";
    opendir( my $dir, $api_path ) or die "Unable to open directory: $!";
    while ( my $file = readdir($dir) ) {
        next if $file eq '.';
        next if $file eq '..';
        print STDERR "# File/List.pm: File is: $file\n";
        if ( -f ($api_path . $file) ) {
            push @files, $file;
        }
    }
    closedir $dir;
    print STDERR "# File/List.pm: Files are:\n";
    print STDERR "# File/List.pm: get_api_list: \n" . Dumper( \@files ) . "\n";

    return \@files;
}

1;