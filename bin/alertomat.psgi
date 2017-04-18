#!perl

use 5.010;
use warnings;
use strict;

use lib qw(lib);

use TOML;
use Alertomat;

my $config = from_toml(do { local (@ARGV, $/) = ('alertomat.toml'); <> });

# XXX actually check config and explode into objects
my $alertomat = Alertomat->new(config => $config);
$alertomat->to_app;
