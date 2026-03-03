use Test::More tests => 6;
use strict;
use warnings;

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/../lib";
    use local::lib "$FindBin::Bin/../local-lib";
}

use Slic3r;
use Slic3r::Test;

{
    my $config = Slic3r::Config->new_from_defaults;
    $config->set('perimeter_extrusion_width', '250%');
    ok $config->validate, 'percent extrusion width is validated';

    is $config->slice_angle, 0, 'slice_angle default is 0';

    $config->set('slice_angle', 0);
    ok $config->validate, 'slice_angle accepts 0';

    $config->set('slice_angle', 30);
    ok $config->validate, 'slice_angle accepts typical value';

    $config->set('slice_angle', 100);
    like exception { $config->validate }, qr/--slice-angle must be between 0 and 89\.9 degrees/,
        'slice_angle rejects out-of-range values';

    $config->set('slice_angle', 'abc');
    like exception { $config->validate }, qr/Invalid value for --slice-angle/,
        'slice_angle rejects malformed values';

    $config->set('slice_angle', 0);
    my $print = Slic3r::Test::init_print('20mm_cube', config => $config, scale => 2);
}

__END__
