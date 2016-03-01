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

# X::Crane::Add::RO {{{

class Add::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: add requested modifying an immutable $.typename";
    }
}

# end X::Crane::Add::RO }}}

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

# X::Crane::CopyFromNotFound {{{

class CopyFromNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: copy operation failed, from location nonexistent';
    }
}

# end X::Crane::CopyFromNotFound }}}

# X::Crane::CopyParentToChild {{{

class CopyParentToChild is Exception
{
    method message()
    {
        say '✗ Crane error: a location cannot be copied into one of its children';
    }
}

# end X::Crane::CopyParentToChild }}}

# X::Crane::CopyPathNotFound {{{

class CopyPathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: copy operation failed, path nonexistent';
    }
}

# end X::Crane::CopyPathNotFound }}}

# X::Crane::CopyPath::RO {{{

class CopyPath::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: requested copy path is immutable $.typename";
    }
}

# end X::Crane::CopyPath::RO }}}

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

# X::Crane::RemovePathNotFound {{{

class RemovePathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: remove operation failed, path not found in container';
    }
}

# end X::Crane::RemovePathNotFound }}}

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

# X::Crane::ReplacePathNotFound {{{

class ReplacePathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: replace operation failed, path not found in container';
    }
}

# end X::Crane::ReplacePathNotFound }}}

# X::Crane::Replace::RO {{{

class Replace::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: replace requested modifying an immutable $.typename";
    }
}

# end X::Crane::Replace::RO }}}

# X::Crane::TestPathNotFound {{{

class TestPathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: test operation failed, path nonexistent';
    }
}

# end X::Crane::TestPathNotFound }}}

# X::Crane::TransformCallableRaisedException {{{

class TransformCallableRaisedException is Exception
{
    method message()
    {
        say '✗ Crane error: transform operation failed, callable raised exception';
    }
}

# end X::Crane::TransformCallableRaisedException }}}

# X::Crane::TransformCallableSignatureParams {{{

class TransformCallableSignatureParams is Exception
{
    method message()
    {
        say '✗ Crane error: transform operation failed, faulty callable signature';
    }
}

# end X::Crane::TransformCallableSignatureParams }}}

# X::Crane::TransformPathNotFound {{{

class TransformPathNotFound is Exception
{
    method message()
    {
        say '✗ Crane error: transform operation failed, path nonexistent';
    }
}

# end X::Crane::TransformPathNotFound }}}

# X::Crane::Transform::RO {{{

class Transform::RO is Exception
{
    has $.typename;
    method message()
    {
        say "✗ Crane error: transform requested modifying an immutable $.typename";
    }
}

# end X::Crane::Transform::RO }}}

# vim: ft=perl6 fdm=marker fdl=0
