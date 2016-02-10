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
    is at(%data, 'legumes').WHAT, Array, "It's an Array";
    is %data.at('legumes').WHAT, Array, "It's an Array";
    is at(%data, 'legumes', 0).WHAT, Hash, "It's a Hash";
    is %data.at('legumes', 0).WHAT, Hash, "It's a Hash";
    is at(%data, 'legumes', 1).WHAT, Hash, "It's a Hash";
    is %data.at('legumes', 1).WHAT, Hash, "It's a Hash";
    is at(%data, 'legumes', 2).WHAT, Hash, "It's a Hash";
    is %data.at('legumes', 2).WHAT, Hash, "It's a Hash";
    is at(%data, 'legumes', 3).WHAT, Hash, "It's a Hash";
    is %data.at('legumes', 3).WHAT, Hash, "It's a Hash";

    is at(%data, 'legumes', 0, 'instock'), 4, "It's the value expected";
    is at(%data, qw<legumes 0 instock>), 4, "It's the value expected";
    is %data.at(qw<legumes 0 instock>), 4, "It's the value expected";
    is %data.at(qw<legumes 0>)<instock>, 4, "It's the value expected";
    my @path = 'legumes', 1, 'instock';
    is at(%data, @path), 21, "It's the value expected";
    is %data.at(@path), 21, "It's the value expected";
    is %data.at(|@path), 21, "It's the value expected";
    sub getpath() { qw<legumes 2 instock> }
    is at(%data, getpath()), 13, "It's the value expected";
    is %data.at('legumes').at(2).at(<instock>), 13, "It's the value expected";
    is %data.at(qw<legumes 2>).at(<instock>), 13, "It's the value expected";
    is %data.at(<legumes>)[2].at(<instock>), 13, "It's the value expected";
    is %data<legumes>[2].at(<instock>), 13, "It's the value expected";
    is at(%data, 'legumes', 3, 'instock'), 8, "It's the value expected";
}

# vim: ft=perl6