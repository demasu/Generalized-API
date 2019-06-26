package Generic::API::Template::Variables;

use strict;
use warnings;

sub get_links {
    my ($requested_page) = @_;

    my $href_base = '//astudyinfutility.com/fancy/';
    my @links;
    my %items = (
        'input'  => {
            href => $href_base,
            text => 'Enter New API',
        },
        'verify' => {
            href => $href_base . 'verify',
            text => 'Verify An API',
        },
        'test'   => {
            href => $href_base . 'test',
            text => 'Test An API',
        },
    );
    my @pages = qw( input verify test );

    foreach my $page ( @pages ) {
        my $active;
        if ( $page =~ /$requested_page/i ) {
            $active = ' class="active"';
        }
        else {
            $active = '';
        }
        my $obj = {
            active => $active,
            href   => $items{$page}->{href},
            text   => $items{$page}->{text},
        };
        push @links, $obj;
    }

    return \@links;
}

1;
