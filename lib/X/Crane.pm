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

# X::Crane::AtRwInvalidStep {{{

class AtRwInvalidStep is Exception
{
    has $.error;
    method message()
    {
        my Str $message = qq:to/EOF/;
        ✗ Crane error: at-rw requested invalid step
          Causative error message:「{$.error.payload}」
          Causative error type:「{$.error.WHAT.perl}」
        EOF
        say $message.trim;
    }
}

# end X::Crane::AtRwInvalidStep }}}

# X::Crane::AtRwRequestedROContainerReassignment {{{

class AtRwRequestedROContainerReassignment is Exception
{
    method message()
    {
        say "✗ Crane error: at-rw requested reassigning immutable container";
    }
}

# end X::Crane::AtRwRequestedROContainerReassignment }}}

# X::Crane::NonAssociativeKeyAssociative {{{

class NonAssociativeKeyAssociative is Exception {*}

# end X::Crane::NonAssociativeKeyAssociative }}}

# X::Crane::NonPositionalIndexInt {{{

class NonPositionalIndexInt is Exception {*}

# end X::Crane::NonPositionalIndexInt }}}

# X::Crane::NonPositionalIndexWhateverCode {{{

class NonPositionalIndexWhateverCode is Exception {*}

# end X::Crane::NonPositionalIndexWhateverCode }}}

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
        say '✗ Crane error: positional index does not exist';
    }
}

# end X::Crane::PositionalIndexDNE }}}

# X::Crane::PositionalIndexInvalid {{{

class PositionalIndexInvalid is Exception
{
    has Str $.classifier;
    method message()
    {
        my Str $error-message;
        given $.classifier
        {
            when 'INTM'
            {
                $error-message =
                    'unsupported use of negative subscript to index Positional';
            }
            when 'OTHER'
            {
                $error-message = 'given Positional index invalid';
            }
        }
        say "✗ Crane error: $error-message";
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
