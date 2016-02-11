use v6;
use lib 'lib';
use lib 't/lib';
use Test;
use Crane;
use TestCrane;

plan 1;

subtest
{
    my %data = %TestCrane::data;
    is Crane.exists(%data, []), True, 'Exists';
    is Crane.exists(%data, ['legumes']), True, 'Exists';
    is Crane.exists(%data, qw<legumes 0>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 0 instock>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 0 name>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 0 unit>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 1>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 1 instock>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 1 name>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 1 unit>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 2>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 2 instock>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 2 name>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 2 unit>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 3>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 3 instock>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 3 name>), True, 'Exists';
    is Crane.exists(%data, qw<legumes 3 unit>), True, 'Exists';
}

# vim: ft=perl6
