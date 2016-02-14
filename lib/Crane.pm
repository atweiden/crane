use v6;
use X::Crane;
unit class Crane;

# at {{{

use MONKEY-TYPING;
augment class Array { method at(*@steps) { at(self, @steps) } }
augment class Hash { method at(*@steps) { at(self, @steps) } }
augment class List { method at(*@steps) { at(self, @steps) } }
augment class Map { method at(*@steps) { at(self, @steps) } }
augment class Pair { method at(*@steps) { at(self, @steps) } }
augment class Range { method at(*@steps) { at(self, @steps) } }

sub at($data, *@steps) is rw is export
{
    my $root := $data;
    return-rw _at($root, @steps);
}

# Associative handling {{{

multi sub _at(Associative $data, @steps where *.elems > 1) is rw
{
    my $root := $data;
    if $root{@steps[0]}:exists
    {
        $root := $root{@steps[0]};
    }
    else
    {
        die X::Crane::AssociativeKeyDNE.new;
    }
    return-rw _at($root, @steps[1..*]);
}

multi sub _at(Associative $data, @steps where *.elems == 1) is rw
{
    my $root := $data;
    if $root{@steps[0]}:exists
    {
        $root := $root{@steps[0]};
    }
    else
    {
        die X::Crane::AssociativeKeyDNE.new;
    }
    return-rw $root;
}

multi sub _at(Associative $data, @steps where *.elems == 0) is rw
{
    return-rw $data;
}

multi sub _at(Associative $data) is rw
{
    return-rw $data;
}

# end Associative handling }}}

# Positional handling {{{

multi sub _at(Positional $data, @steps where *.elems > 1) is rw
{
    my $root := $data;

    try
    {
        unless is-valid-positional-index(@steps[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    if $root[@steps[0]]:exists
    {
        $root := $root[@steps[0]];
    }
    else
    {
        die X::Crane::PositionalIndexDNE.new;
    }
    return-rw _at($root, @steps[1..*]);
}

multi sub _at(Positional $data, @steps where *.elems == 1) is rw
{
    my $root := $data;

    try
    {
        unless is-valid-positional-index(@steps[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    if $root[@steps[0]]:exists
    {
        $root := $root[@steps[0]];
    }
    else
    {
        die X::Crane::PositionalIndexDNE.new;
    }
    return-rw $root;
}

multi sub _at(Positional $data, @steps where *.elems == 0) is rw
{
    return-rw $data;
}


multi sub _at(Positional $data) is rw
{
    return-rw $data;
}

# end Positional handling }}}

# end at }}}

# at-rw {{{

sub at-rw($container, *@steps) is rw is export
{
    my $root := $container;

    my @steps-taken; # for backtracing steps
    loop (my Int $i = 0; $i < @steps.elems; $i++)
    {
        my Bool %failed; # for storing exception type encountered
        CATCH
        {
            when X::Crane::NonAssociativeKeyAssociative
            {
                %failed{.^name}++;
                .resume;
            }
            when X::Crane::NonPositionalIndexInt
            {
                %failed{.^name}++;
                .resume;
            }
            when X::Crane::NonPositionalIndexWhateverCode
            {
                %failed{.^name}++;
                .resume;
            }
            default
            {
                die "✗ Crane accident:「{dd $_}」";
            }
        }

        $root := step($root, @steps[$i]);

        if %failed.keys.grep({.defined})
        {
            # assess why it failed
            given %failed.keys.grep({.defined})[0]
            {
                when 'X::Crane::NonAssociativeKeyAssociative'
                {
                    # change last step to Associative type (overwrite)
                    at-rw($container, @steps-taken) = {};
                    $root := at-rw($container, @steps);
                    last;
                }
                when 'X::Crane::NonPositionalIndexInt'
                {
                    # change last step to Positional type (overwrite)
                    at-rw($container, @steps-taken) = [];
                    $root := at-rw($container, @steps);
                    last;
                }
                when 'X::Crane::NonPositionalIndexWhateverCode'
                {
                    # change last step to Positional type (overwrite)
                    at-rw($container, @steps-taken) = [];
                    $root := at-rw(
                        $container,
                        @steps-taken,
                        null-step($container.at(@steps-taken), @steps[$i]),
                        @steps[$i+1..*]
                    );
                    last;
                }
                default
                {
                    die "✗ Crane accident:「{dd $_}」";
                }
            }
        }
        else
        {
            # step succeeded (convert would-be WhateverCode Positional
            # indices into hard-coded Int indices)
            push @steps-taken, @steps[$i].isa(WhateverCode)
                ?? null-step($container.at(@steps-taken), @steps[$i])
                !! @steps[$i];
        }
    }

    return-rw $root;
}

multi sub step($container where {$_ !~~ Positional}, Int $step)
{
    X::Crane::NonPositionalIndexInt.new.throw;
}

multi sub step($container where {$_ !~~ Positional}, WhateverCode $step)
{
    X::Crane::NonPositionalIndexWhateverCode.new.throw;
}

multi sub step(Positional $container, Int $step) is rw
{
    my $root := $container;
    try
    {
        CATCH
        {
            default
            {
                die X::Crane::AtRwInvalidStep.new(:error($_));
            }
        }
        $root := $root[$step];
    }
    return-rw $root;
}

multi sub step(Positional $container, WhateverCode $step) is rw
{
    my $root := $container;
    try
    {
        CATCH
        {
            default
            {
                die X::Crane::AtRwInvalidStep.new(:error($_));
            }
        }
        $root := $root[$step];
    }
    return-rw $root;
}

multi sub step($container where {$_ !~~ Associative}, $step)
{
    X::Crane::NonAssociativeKeyAssociative.new.throw;
}

multi sub step($container, $step) is rw
{
    my $root := $container;
    try
    {
        CATCH
        {
            default
            {
                die X::Crane::AtRwInvalidStep.new(:error($_));
            }
        }
        $root := $root{$step};
    }
    return-rw $root;
}

# end at-rw }}}

# exists {{{

method exists($container, :@path!, Bool :$k = True, Bool :$v) returns Bool
{
    $v.so ?? exists-value($container, @path) !! exists-key($container, @path);
}

# exists-key {{{

multi sub exists-key($container, @path where *.elems > 1) returns Bool
{
    exists-key($container, [@path[0]])
        ?? exists-key($container.at(@path[0]), @path[1..*])
        !! False;
}

multi sub exists-key(
    Associative $container,
    @path where *.elems == 1
) returns Bool
{
    $container{@path[0]}:exists;
}

multi sub exists-key(
    Associative $container,
    @path where *.elems == 0
) returns Bool
{
    $container.defined;
}

multi sub exists-key(
    Positional $container,
    @path where *.elems == 1
) returns Bool
{
    try
    {
        unless is-valid-positional-index(@path[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    $container[@path[0]]:exists;
}

multi sub exists-key(
    Positional $container,
    @path where *.elems == 0
) returns Bool
{
    $container.defined;
}

# end exists-key }}}

# exists-value {{{

multi sub exists-value($container, @path where *.elems > 1) returns Bool
{
    exists-value($container, [@path[0]])
        ?? exists-value($container.at(@path[0]), @path[1..*])
        !! False;
}

multi sub exists-value(
    Associative $container,
    @path where *.elems == 1
) returns Bool
{
    $container{@path[0]}.defined;
}

multi sub exists-value(
    Associative $container,
    @path where *.elems == 0
) returns Bool
{
    $container.defined;
}

multi sub exists-value(
    Positional $container,
    @path where *.elems == 1
) returns Bool
{
    try
    {
        unless is-valid-positional-index(@path[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    $container[@path[0]].defined;
}

multi sub exists-value(
    Positional $container,
    @path where *.elems == 0
) returns Bool
{
    $container.defined;
}

# end exists-value }}}

# end exists }}}

# get {{{

multi method get(
    $container,
    :@path!,
    Bool :$k! where *.so,
    Bool :$v where *.not,
    Bool :$p where *.not
) returns Any
{
    get-key($container, @path);
}

multi method get(
    $container,
    :@path!,
    Bool :$k where *.not,
    Bool :$v = True,
    Bool :$p where *.not
) returns Any
{
    get-value($container, @path);
}

multi method get(
    $container,
    :@path!,
    Bool :$k where *.not,
    Bool :$v where *.not,
    Bool :$p! where *.so
) returns Any
{
    get-pair($container, @path);
}

# get-key {{{

multi sub get-key($container, @path where *.elems > 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? get-key($container.at(@path[0]), @path[1..*])
        !! die X::Crane::PathDNE.new;
}

multi sub get-key(Associative $container, @path where *.elems == 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? ($container{@path[0]}:!k)
        !! die X::Crane::PathDNE.new;
}

multi sub get-key(Associative $container, @path where *.elems == 0) returns Any
{
    die X::Crane::RootContainerKeyOp.new;
}

multi sub get-key(Positional $container, @path where *.elems == 1) returns Any
{
    try
    {
        unless is-valid-positional-index(@path[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    exists-key($container, [@path[0]])
        ?? ($container[@path[0]]:!k)
        !! die X::Crane::PathDNE.new;
}

multi sub get-key(Positional $container, @path where *.elems == 0) returns Any
{
    die X::Crane::RootContainerKeyOp.new;
}

# end get-key }}}

# get-value {{{

multi sub get-value($container, @path where *.elems > 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? get-value($container.at(@path[0]), @path[1..*])
        !! die X::Crane::PathDNE.new;
}

multi sub get-value(Associative $container, @path where *.elems == 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? ($container{@path[0]}:!v)
        !! die X::Crane::PathDNE.new;
}

multi sub get-value(Associative $container, @path where *.elems == 0) returns Any
{
    $container;
}

multi sub get-value(Positional $container, @path where *.elems == 1) returns Any
{
    try
    {
        unless is-valid-positional-index(@path[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    exists-key($container, [@path[0]])
        ?? ($container[@path[0]]:!v)
        !! die X::Crane::PathDNE.new;
}

multi sub get-value(Positional $container, @path where *.elems == 0) returns Any
{
    $container;
}

# end get-value }}}

# get-pair {{{

multi sub get-pair($container, @path where *.elems > 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? get-pair($container.at(@path[0]), @path[1..*])
        !! die X::Crane::PathDNE.new;
}

multi sub get-pair(Associative $container, @path where *.elems == 1) returns Any
{
    exists-key($container, [@path[0]])
        ?? ($container{@path[0]}:!p)
        !! die X::Crane::PathDNE.new;
}

multi sub get-pair(Associative $container, @path where *.elems == 0) returns Any
{
    die X::Crane::RootContainerKeyOp.new;
}

multi sub get-pair(Positional $container, @path where *.elems == 1) returns Any
{
    try
    {
        unless is-valid-positional-index(@path[0])
        {
            die X::Crane::PositionalIndexInvalid.new;
        }

        CATCH
        {
            default
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    exists-key($container, [@path[0]])
        ?? ($container[@path[0]]:!p)
        !! die X::Crane::PathDNE.new;
}

multi sub get-pair(Positional $container, @path where *.elems == 0) returns Any
{
    die X::Crane::RootContainerKeyOp.new;
}

# end get-pair }}}

# end get }}}

# helper functions {{{

# check for non-integer positional index
multi sub is-valid-positional-index(Int $step) returns Bool
{
    True;
}

# passing *-1 is ok
multi sub is-valid-positional-index(WhateverCode $step) returns Bool
{
    True;
}

# passing stringified integers is ok
multi sub is-valid-positional-index($step) returns Bool
{
    my $n;
    try
    {
        # convert string into number
        $n = +$step;
        CATCH
        {
            when X::Str::Numeric
            {
                die X::Crane::PositionalIndexInvalid.new;
            }
        }
    }

    $n.isa: Int;
}

# convert WhateverCode to Int Positional index
# helps prevent infinite loops
sub null-step(Positional $container, WhateverCode $step) returns Int
{
    # $container.elems for *-0
    my Int $elems = $container.elems // 0;
    my Int $null-index = $container[$step]:k ?? ($container[$step]:k) !! $elems;
}

# end helper functions }}}

# vim: ft=perl6 fdm=marker fdl=0
