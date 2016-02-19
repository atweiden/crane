# TODO

## fix infinite looping

examples that don't work:

```perl6
my %h;
at-rw(%h, 'a', *-0, 0) = 'one'; # works once
at-rw(%h, 'a', *-0, 0) = 'one'; # infinite loop here
```

```perl6
my %h;
at-rw(%h, 'a', *-0, 'b') = 'z'; # works once
at-rw(%h, 'a', *-0, 'b') = 'z'; # infinite loop here
```

```perl6
at-rw(my @a, *-0, 0) = 'align'; # infinite loop here
```

can do this repeatedly without issue:

```perl
my @a;
at-rw(@a, *-0) = 'one'; # works
at-rw(@a, *-0) = 'one'; # works
at-rw(@a, *-0) = 'one'; # works
at-rw(@a, *-0) = 'one'; # works
at-rw(@a, *-0) = 'one'; # works
```

## warn about Range type handling

- `$container.deepmap(*.clone)` transforms nested Range types into
  List equivalent.
  - `my $root = $container.deepmap(*.clone)` is needed to prevent mutating
    original container, so I don't see how this can be avoided
    - on the plus side, Ranges are converted into List equivalent when
      serializing to JSON
