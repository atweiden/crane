# TODO

## fix infinite looping

examples that don't work:

```perl6
my %h;
at-rw(%h, 'a', *-0, 0, *-0, *-0) = 'one'; # works once
at-rw(%h, 'a', *-0, 0, *-0, *-0) = 'one'; # infinite loop here
```

```perl6
my %h;
at-rw(%h, 'a', *-0, 'b') = 'z'; # works once
at-rw(%h, 'a', *-0, 'b') = 'z'; # infinite loop here
```

```perl6
at-rw(my @a, *-0, 0) = 'one'; # infinite loop here
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
