use v6;
use X::Crane;
unit class Crane;

# at {{{

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
    validate-positional-index(@steps[0]);
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
    validate-positional-index(@steps[0]);
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
            when .payload eq "Cannot assign to a readonly variable or a value"
            {
                die X::Crane::AtRwRequestedROContainerReassignment.new;
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
                        null-step(at($container, @steps-taken), @steps[$i]),
                        @steps[$i+1..*]
                    );
                    last;
                }
            }
        }
        else
        {
            # step succeeded (convert would-be WhateverCode Positional
            # indices into hard-coded Int indices)
            push @steps-taken, @steps[$i].isa(WhateverCode)
                ?? null-step(at($container, @steps-taken), @steps[$i])
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
        ?? exists-key(at($container, @path[0]), @path[1..*])
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
    die X::Crane::RootContainerKeyOp.new;
}

multi sub exists-key(
    Positional $container,
    @path where *.elems == 1
) returns Bool
{
    validate-positional-index(@path[0]);
    $container[@path[0]]:exists;
}

multi sub exists-key(
    Positional $container,
    @path where *.elems == 0
) returns Bool
{
    die X::Crane::RootContainerKeyOp.new;
}

# end exists-key }}}

# exists-value {{{

multi sub exists-value($container, @path where *.elems > 1) returns Bool
{
    exists-value($container, [@path[0]])
        ?? exists-value(at($container, @path[0]), @path[1..*])
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
    validate-positional-index(@path[0]);
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
        ?? get-key(at($container, @path[0]), @path[1..*])
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
    validate-positional-index(@path[0]);
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
        ?? get-value(at($container, @path[0]), @path[1..*])
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
    validate-positional-index(@path[0]);
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
        ?? get-pair(at($container, @path[0]), @path[1..*])
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
    validate-positional-index(@path[0]);
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

# add {{{

method add($container, :@path!, :$value!) returns Any
{
    # the Crane.add operation will fail when @path DNE in $container
    # with rules similar to JSON Patch (X::Crane::AddPathNotFound)
    #
    # the Crane.add operation will fail when @path[*-1] is invalid for
    # the container type according to Crane syntax rules:
    #
    #   if @path[*-2] is Positional, then @path[*-1] must be
    #   Int/WhateverCode
    #
    # the Crane.add operation will fail when it's invalid to set
    # $container at @path to $value, such as when $container at @path
    # is an immutable value (X::Crane::Assignment::RO)
    CATCH
    {
        when X::Assignment::RO
        {
            die X::Crane::Assignment::RO.new(:typename(.typename));
        }
    }

    # route add operation based on path length
    add($container, :@path, :$value);
}

multi sub add($container, :@path! where *.elems > 1, :$value!) returns Any
{
    unless Crane.exists($container, :path(@path[0..^*-1]), :v)
    {
        die X::Crane::AddPathNotFound.new;
    }

    # route add operation based on destination type
    given at($container, @path[0..^*-1]).WHAT
    {
        when Associative
        {
            # add pair to existing Associative (or replace existing pair)
            add-to-associative(
                :$container,
                :path(@path[0..^*-1]),
                :step(@path[*-1]),
                :$value
            );
        }
        when Positional
        {
            validate-positional-index(@path[*-1]);

            # splice in $value to Positional
            add-to-positional(
                :$container,
                :path(@path[0..^*-1]),
                :step(@path[*-1]),
                :$value
            );
        }
        default
        {
            # invalid path request that should never happen
            # how did we get here?
            # if:
            #
            #     Crane.exists($container, :path(@path[0..^*-1]), :v)
            #
            # and we have a path with >1 elems, then we must be entering
            # either an Associative or a Positional container
            # at($container, @path[0..^*-1])
            die '✗ Crane accident: add operation failed, invalid path';
        }
    }
}

multi sub add($container, :@path! where *.elems == 1, :$value!) returns Any
{
    unless Crane.exists($container, :path(), :v)
    {
        die X::Crane::AddPathNotFound.new;
    }

    # route add operation based on destination type
    given $container.WHAT
    {
        when Associative
        {
            # add pair to existing Associative (or replace existing pair)
            add-to-associative(:$container, :step(@path[*-1]), :$value);
        }
        when Positional
        {
            validate-positional-index(@path[*-1]);

            # splice in $value to Positional
            add-to-positional(:$container, :step(@path[*-1]), :$value);
        }
        default
        {
            # invalid path request that should never happen
            # how did we get here?
            # if:
            #
            #     Crane.exists($container, :path(@path[0..^*-1]), :v)
            #
            # and we have a path with 1 elem, then we must be entering
            # either an Associative or a Positional container
            # at($container, @path[0..^*-1])
            die '✗ Crane accident: add operation failed, invalid path';
        }
    }
}

multi sub add($container, :@path! where *.elems == 0, :$value!) returns Any
{
    given $container.WHAT
    {
        when Associative
        {
            add-to-associative(:$container, :$value);
        }
        when Positional
        {
            add-to-positional(:$container, :$value);
        }
        default
        {
            add-to-any(:$container, :$value);
        }
    }
}

# Associative handling {{{

multi sub add-to-associative(:$container!, :@path!, :$step!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    at($root, @path){$step} = $value;
    $root;
}

multi sub add-to-associative(:$container!, :$step!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    $root{$step} = $value;
    $root;
}

multi sub add-to-associative(:$container!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    $root = $value;
    $root;
}

# end Associative handling }}}

# Positional handling {{{

multi sub add-to-positional(:$container!, :@path!, :$step!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);

    # XXX when $value is a multi-dimensional array, splice ruins it by
    # flattening it (splice's signature is *@target-to-splice-in)
    #
    # we have to inspect the structure of $value and work around this
    # to provide a sane api
    if $value ~~ Positional
    {
        my @value = $[ $value.deepmap(*.clone) ];
        at($root, @path).splice($step, 0, @value);
    }
    else
    {
        at($root, @path).splice($step, 0, $value);
    }
    |$root;
}

multi sub add-to-positional(:$container!, :$step!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    if $value ~~ Positional
    {
        my @value = $[ $value.deepmap(*.clone) ];
        $root.splice($step, 0, @value);
    }
    else
    {
        $root.splice($step, 0, $value);
    }
    |$root;
}

multi sub add-to-positional(:$container!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    $root = $value;
    |$root;
}

# end Positional handling }}}

# Any handling {{{

sub add-to-any(:$container!, :$value!) returns Any
{
    my $root = $container.deepmap(*.clone);
    $root = $value;
    $root;
}

# end Any handling }}}

# end add }}}

# helper functions {{{

# INT0P: Int where * >= 0 (valid)
# WEC: WhateverCode (valid)
# INTM: Int where * < 0 (invalid)
# OTHER: everything else (invalid)
enum Classifier <INT0P INTM OTHER WEC>;

# classify positional index requests for better error messages
multi sub get-positional-index-classifier(Int $ where * >= 0) returns Classifier
{
    INT0P;
}
multi sub get-positional-index-classifier(Int $ where * < 0) returns Classifier
{
    INTM;
}
multi sub get-positional-index-classifier(WhateverCode $) returns Classifier
{
    WEC;
}
multi sub get-positional-index-classifier($) returns Classifier
{
    OTHER;
}

multi sub test-positional-index-classifier(INT0P) {*}
multi sub test-positional-index-classifier(WEC) {*}
multi sub test-positional-index-classifier(INTM)
{
    die X::Crane::PositionalIndexInvalid.new(:classifier<INTM>);
}
multi sub test-positional-index-classifier(OTHER)
{
    die X::Crane::PositionalIndexInvalid.new(:classifier<OTHER>);
}

sub validate-positional-index($step)
{
    test-positional-index-classifier(get-positional-index-classifier($step));
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
