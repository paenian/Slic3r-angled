use strict;
use warnings;
use utf8;

use Slic3r::Test;
use Test::More tests => 4;

{
    my $config = Slic3r::Config->new_from_defaults;
    $config->set('slice_angle', 0);
    my $print = Slic3r::Test::init_print('20mm_cube', config => $config);
    ok my $gcode = Slic3r::Test::gcode($print), 'slice_angle=0 keeps legacy horizontal slicing path';
}

{
    my $config = Slic3r::Config->new_from_defaults;
    $config->set('slice_angle', 10);
    my $print = Slic3r::Test::init_print('20mm_cube', config => $config);
    ok my $gcode = Slic3r::Test::gcode($print), 'slice_angle>0 can be sliced without support';

    my $layers = $print->objects->[0]->layers;
    cmp_ok(scalar(@$layers), '>', 2, 'multiple layers were generated for angled slicing');
}

{
    my $config = Slic3r::Config->new_from_defaults;
    $config->set('slice_angle', 10);
    $config->set('support_material', 1);

    my $err;
    eval {
        my $print = Slic3r::Test::init_print('20mm_cube', config => $config);
        Slic3r::Test::gcode($print);
    };
    $err = $@;
    like($err, qr/slice_angle is not yet compatible with support material generation/, 'unsupported slice_angle+support fails fast');
}
