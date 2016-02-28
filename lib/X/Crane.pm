use v6;
unit module X::Crane;

# X::Crane::AddPathNotFound {{{

class AddPathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: add operation failed, path not found in container';
    }
}

# end X::Crane::AddPathNotFound }}}

# X::Crane::Assignment::RO {{{

class Assignment::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: requested modifying an immutable $.typename";
    }
}

# end X::Crane::Assignment::RO }}}

# X::Crane::AssociativeKeyDNE {{{

class AssociativeKeyDNE is Exception
{
    method message()
    {
        say '✗ Crane error: associative key does not exist';
    }
}

# end X::Crane::AssociativeKeyDNE }}}

# X::Crane::ChiselInvalidStep {{{

class ChiselInvalidStep is Exception
{
    has $.error;
    method message()
    {
        my Str $message = qq:to/EOF/;
        ✗ Crane error: chisel requested invalid step
          Causative error message:「{$.error.payload}」
          Causative error type:「{$.error.WHAT.perl}」
        EOF
        say $message.trim;
    }
}

# end X::Crane::ChiselInvalidStep }}}

# X::Crane::ChiselRequestedROContainerReassignment {{{

class ChiselRequestedROContainerReassignment is Exception
{
    method message()
    {
        say "✗ Crane error: chisel requested reassigning immutable container";
    }
}

# end X::Crane::ChiselRequestedROContainerReassignment }}}

# X::Crane::GetPathNotFound {{{

class GetPathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: get operation failed, path nonexistent';
    }
}

# end X::Crane::GetPathNotFound }}}

# X::Crane::GetRootContainerKey {{{

class GetRootContainerKey is Exception
{
    method message()
    {
        say '✗ Crane error: cannot request key operations on container root';
    }
}

# end X::Crane::GetRootContainerKey }}}

# X::Crane::MoveFromNotFound {{{

class MoveFromNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: move operation failed, from location nonexistent';
    }
}

# end X::Crane::MoveFromNotFound }}}

# X::Crane::MoveFrom::RO {{{

class MoveFrom::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: requested move from immutable $.typename";
    }
}

# end X::Crane::MoveFrom::RO }}}

# X::Crane::MoveParentToChild {{{

class MoveParentToChild is Exception
{
    method message()
    {
        say '✗ Crane error: a location cannot be moved into one of its children';
    }
}

# end X::Crane::MoveParentToChild }}}

# X::Crane::MovePathNotFound {{{

class MovePathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: move operation failed, path nonexistent';
    }
}

# end X::Crane::MovePathNotFound }}}

# X::Crane::MovePath::RO {{{

class MovePath::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: requested move path is immutable $.typename";
    }
}

# end X::Crane::MovePath::RO }}}

# X::Crane::NonAssociativeKeyAssociative {{{

class NonAssociativeKeyAssociative is Exception {*}

# end X::Crane::NonAssociativeKeyAssociative }}}

# X::Crane::NonPositionalIndexInt {{{

class NonPositionalIndexInt is Exception {*}

# end X::Crane::NonPositionalIndexInt }}}

# X::Crane::NonPositionalIndexWhateverCode {{{

class NonPositionalIndexWhateverCode is Exception {*}

# end X::Crane::NonPositionalIndexWhateverCode }}}

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

# X::Crane::Remove::RO {{{

class Remove::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: requested remove operation on immutable $.typename";
    }
}

# end X::Crane::Remove::RO }}}

# X::Crane::RemovePathNotFound {{{

class RemovePathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: remove operation failed, path not found in container';
    }
}

# end X::Crane::RemovePathNotFound }}}

# X::Crane::ReplacePathNotFound {{{

class ReplacePathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: replace operation failed, path not found in container';
    }
}

# end X::Crane::ReplacePathNotFound }}}

# vim: ft=perl6 fdm=marker fdl=0
