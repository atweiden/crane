use v6;
use lib 'lib';
use lib 't/lib';
use Test;
use Crane;
use TestCrane;

plan 1;

subtest
{
    my %h;

    at-rw(%h, qw<a b c>) = 'Sea';
    is %h<a><b><c>, 'Sea', 'Is expected value';

    at-rw(%h, qw<d e f>) = 'Bass';
    is %h<d><e><f>, 'Bass', 'Is expected value';

    at-rw(%h, qw<d>, 0) = 'Fail?';
    is %h<d>[0], 'Fail?', 'Is expected value';

    at-rw(%h, qw<g>, 0) = 'Maybe this time?';
    is %h<g>[0], 'Maybe this time?', 'Is expected value';

    at-rw(%h, qw<g h i j k l m n o p q r s t u v>, 10, 9, 8, 7, 6) = 'Y';
    is %h<g><h><i><j><k><l><m><n><o><p><q><r><s><t><u><v>[10][9][8][7][6], 'Y',
        'Is expected value';

    at-rw(%h, qw<h>) = [];
    is %h<h>, [], 'Is expected value';

    at-rw(%h, qw<h 0 f>) = 'Hasselhoff';
    is %h<h><0><f>, 'Hasselhoff', 'Is expected value';

    at-rw(%h, qw<h 0 f>) = 'Not Hasselhoff';
    is %h<h><0><f>, 'Not Hasselhoff', 'Is expected value';

    my %i;
    at-rw(%i, qw<a b c>, *-0, *-0, *-0, *-0, *-0) = 'five';
    at-rw(%i, qw<a b c>, *-0, *-0, *-0, *-0, *-0) = 'five again';
    is %i<a><b><c>[0][0][0][0][0], 'five', 'Is expected value';
    is %i<a><b><c>[1][0][0][0][0], 'five again', 'Is expected value';

    my %data = %TestCrane::data;
    my %legume = :instock(43), :name<black beans>, :unit<lbs>;
    at-rw(%data, 'legumes', *-0) = %legume;
    is %data<legumes>[0]<instock>, 4, 'Is expected value';
    is %data<legumes>[1]<instock>, 21, 'Is expected value';
    is %data<legumes>[2]<instock>, 13, 'Is expected value';
    is %data<legumes>[3]<instock>, 8, 'Is expected value';
    is %data<legumes>[4]<instock>, 43, 'Is expected value';
}

# vim: ft=perl6
