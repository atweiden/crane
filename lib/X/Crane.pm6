use v6;
unit module X::Crane;

# X::Crane::PathOutOfRange {{{

class PathOutOfRange
{
    also is Exception;

    has Str:D $.operation is required;
    has X::OutOfRange:D $.out-of-range is required;

    # parse stringified Range in X::OutOfRange
    my grammar RangeStr
    {
        token integer
        {
            '-'? \d+
        }
        token range-str
        {
            <integer> '..' <integer>
        }
        token TOP
        {
            ^ <range-str> $
        }
    }

    my class RangeStrActions
    {
        method integer($/ --> Nil)
        {
            make(+$/);
        }
        method range-str($/ --> Nil)
        {
            my Int:D @integer = @<integer>.hyper.map({ .made });
            my Range:D $r = @integer[0] .. @integer[1];
            make($r);
        }
        method TOP($/ --> Nil)
        {
            make($<range-str>.made);
        }
    }

    method message(::?CLASS:D: --> Str:D)
    {
        my Int:D $got = $.out-of-range.got;
        my RangeStrActions $actions .= new;
        my Range:D $range =
            RangeStr.parse($.out-of-range.range, :$actions).made;
        my Str:D $reason =
            $got cmp $range > 0
                ?? 'creating sparse Positional not allowed'
                !! 'Positional index out of range';
        $reason ~= ". Is $got, should be in {$range.gist}";
        my Str:D $message =
            "✗ Crane error: $.operation operation failed, $reason";
    }
}

# end X::Crane::PathOutOfRange }}}
# X::Crane::AddPathNotFound {{{

class AddPathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: add operation failed, path not found in container';
    }
}

# end X::Crane::AddPathNotFound }}}
# X::Crane::AddPathOutOfRange {{{

class AddPathOutOfRange
{
    also is PathOutOfRange;
}

# end X::Crane::AddPathOutOfRange }}}
# X::Crane::Add::RO {{{

class Add::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: add requested modifying an immutable $.typename";
    }
}

# end X::Crane::Add::RO }}}
# X::Crane::AssociativeKeyDNE {{{

class AssociativeKeyDNE
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message = '✗ Crane error: associative key does not exist';
    }
}

# end X::Crane::AssociativeKeyDNE }}}
# X::Crane::CopyFromNotFound {{{

class CopyFromNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: copy operation failed, from location nonexistent';
    }
}

# end X::Crane::CopyFromNotFound }}}
# X::Crane::CopyParentToChild {{{

class CopyParentToChild
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: a location cannot be copied '
                ~ 'into one of its children';
    }
}

# end X::Crane::CopyParentToChild }}}
# X::Crane::CopyPathNotFound {{{

class CopyPathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: copy operation failed, path nonexistent';
    }
}

# end X::Crane::CopyPathNotFound }}}
# X::Crane::CopyPathOutOfRange {{{

class CopyPathOutOfRange
{
    also is Exception;

    has Str:D $.add-path-out-of-range is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            $.add-path-out-of-range.subst(/'add operation'/, 'copy operation');
    }
}

# end X::Crane::CopyPathOutOfRange }}}
# X::Crane::CopyPath::RO {{{

class CopyPath::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: requested copy path is immutable $.typename";
    }
}

# end X::Crane::CopyPath::RO }}}
# X::Crane::GetPathNotFound {{{

class GetPathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: get operation failed, path nonexistent';
    }
}

# end X::Crane::GetPathNotFound }}}
# X::Crane::GetRootContainerKey {{{

class GetRootContainerKey
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: cannot request key operations on container root';
    }
}

# end X::Crane::GetRootContainerKey }}}
# X::Crane::ExistsRootContainerKey {{{

class ExistsRootContainerKey
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: cannot request key operations on container root';
    }
}

# end X::Crane::ExistsRootContainerKey }}}
# X::Crane::MoveFromNotFound {{{

class MoveFromNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: move operation failed, from location nonexistent';
    }
}

# end X::Crane::MoveFromNotFound }}}
# X::Crane::MoveFrom::RO {{{

class MoveFrom::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: requested move from immutable $.typename";
    }
}

# end X::Crane::MoveFrom::RO }}}
# X::Crane::MoveParentToChild {{{

class MoveParentToChild
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: a location cannot be moved '
                ~ 'into one of its children';
    }
}

# end X::Crane::MoveParentToChild }}}
# X::Crane::MovePathNotFound {{{

class MovePathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: move operation failed, path nonexistent';
    }
}

# end X::Crane::MovePathNotFound }}}
# X::Crane::MovePathOutOfRange {{{

class MovePathOutOfRange
{
    also is Exception;

    has Str:D $.add-path-out-of-range is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            $.add-path-out-of-range.subst(/'add operation'/, 'move operation');
    }
}

# end X::Crane::MovePathOutOfRange }}}
# X::Crane::MovePath::RO {{{

class MovePath::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: requested move path is immutable $.typename";
    }
}

# end X::Crane::MovePath::RO }}}
# X::Crane::Patch {{{

class Patch
{
    also is Exception;

    has Str:D $.help-text is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message = $.help-text;
    }
}

# end X::Crane::Patch }}}
# X::Crane::PatchAddFailed {{{

class PatchAddFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message = '✗ Crane error: patch operation failed, add failed';
    }
}

# end X::Crane::PatchAddFailed }}}
# X::Crane::PatchCopyFailed {{{

class PatchCopyFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: patch operation failed, copy failed';
    }
}

# end X::Crane::PatchCopyFailed }}}
# X::Crane::PatchMoveFailed {{{

class PatchMoveFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: patch operation failed, move failed';
    }
}

# end X::Crane::PatchMoveFailed }}}
# X::Crane::PatchRemoveFailed {{{

class PatchRemoveFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: patch operation failed, remove failed';
    }
}

# end X::Crane::PatchRemoveFailed }}}
# X::Crane::PatchReplaceFailed {{{

class PatchReplaceFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: patch operation failed, replace failed';
    }
}

# end X::Crane::PatchReplaceFailed }}}
# X::Crane::PatchTestFailed {{{

class PatchTestFailed
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: patch operation failed, test failed';
    }
}

# end X::Crane::PatchTestFailed }}}
# X::Crane::PositionalIndexDNE {{{

class PositionalIndexDNE
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message = '✗ Crane error: positional index does not exist';
    }
}

# end X::Crane::PositionalIndexDNE }}}
# X::Crane::PositionalIndexInvalid {{{

class PositionalIndexInvalid
{
    also is Exception;

    has Str:D $.classifier is required;

    my Str:D $error-message-intm =
        'unsupported use of negative subscript to index Positional';
    my Str:D $error-message-other = 'given Positional index invalid';

    multi method message(
        ::?CLASS:D:
        Str:D $classifier where { $_ eq 'INTM' } = $.classifier
        --> Str:D
    )
    {
        my Str:D $message = "✗ Crane error: $error-message-intm";
    }

    multi method message(
        ::?CLASS:D:
        Str:D $classifier where { $_ eq 'OTHER' } = $.classifier
        --> Str:D
    )
    {
        my Str:D $message = "✗ Crane error: $error-message-other";
    }
}

# end X::Crane::PositionalIndexInvalid }}}
# X::Crane::RemovePathNotFound {{{

class RemovePathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: remove operation failed, path not found '
                ~ 'in container';
    }
}

# end X::Crane::RemovePathNotFound }}}
# X::Crane::Remove::RO {{{

class Remove::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: requested remove operation on immutable $.typename";
    }
}

# end X::Crane::Remove::RO }}}
# X::Crane::ReplacePathNotFound {{{

class ReplacePathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: replace operation failed, path not found '
                ~ 'in container';
    }
}

# end X::Crane::ReplacePathNotFound }}}
# X::Crane::Replace::RO {{{

class Replace::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: replace requested modifying an immutable '
                ~ $.typename;
    }
}

# end X::Crane::Replace::RO }}}
# X::Crane::OpSet::RO {{{

class OpSet::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "✗ Crane error: set requested modifying an immutable $.typename";
    }
}

# end X::Crane::OpSet::RO }}}
# X::Crane::TestPathNotFound {{{

class TestPathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: test operation failed, path nonexistent';
    }
}

# end X::Crane::TestPathNotFound }}}
# X::Crane::TransformCallableRaisedException {{{

class TransformCallableRaisedException
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: transform operation failed, callable raised '
                ~ 'exception';
    }
}

# end X::Crane::TransformCallableRaisedException }}}
# X::Crane::TransformCallableSignatureParams {{{

class TransformCallableSignatureParams
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: transform operation failed, faulty callable '
                ~ 'signature';
    }
}

# end X::Crane::TransformCallableSignatureParams }}}
# X::Crane::TransformPathNotFound {{{

class TransformPathNotFound
{
    also is Exception;

    method message(--> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: transform operation failed, path nonexistent';
    }
}

# end X::Crane::TransformPathNotFound }}}
# X::Crane::Transform::RO {{{

class Transform::RO
{
    also is Exception;

    has Str:D $.typename is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            '✗ Crane error: transform requested modifying an immutable'
                ~ $.typename;
    }
}

# end X::Crane::Transform::RO }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
