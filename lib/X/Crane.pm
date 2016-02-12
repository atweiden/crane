use v6;
unit module X::Crane;

# X::Crane::AssociativeKeyDNE {{{

class AssociativeKeyDNE is Exception
{
    method message()
    {
        say '✗ Crane error: associative key does not exist';
    }
}

# end X::Crane::AssociativeKeyDNE }}}

# X::Crane::PathDNE {{{

class PathDNE is Exception
{
    method message()
    {
        say '✗ Crane error: path nonexistent';
    }
}

# end X::Crane::PathDNE }}}

# X::Crane::PositionalIndexDNE {{{

class PositionalIndexDNE is Exception
{
    method message()
    {
        say '✗ Crane error: positional item does not exist';
    }
}

# end X::Crane::PositionalIndexDNE }}}

# X::Crane::PositionalIndexInvalid {{{

class PositionalIndexInvalid is Exception
{
    method message()
    {
        say '✗ Crane error: cannot request non-integer positional index';
    }
}

# end X::Crane::PositionalIndexInvalid }}}

# X::Crane::RootContainerKeyOp {{{

class RootContainerKeyOp is Exception
{
    method message()
    {
        say '✗ Crane error: cannot request key operations on container root';
    }
}

# end X::Crane::RootContainerKeyOp }}}

# vim: ft=perl6 fdm=marker fdl=0
