# TODO

## fix infinite looping

examples that don't work:

```perl6
at-rw(%h, 'a', *-0, 0, *-0, *-0) = 'one'; # works once
at-rw(%h, 'a', *-0, 0, *-0, *-0) = 'one'; # infinite loop here
```

```perl6
at-rw(my @a, *-0, 0) = 'one'
```

can do this repeatedly without issue:

```perl
at-rw(my @a, *-0) = 'one'
at-rw(my @a, *-0) = 'one'
at-rw(my @a, *-0) = 'one'
at-rw(my @a, *-0) = 'one'
at-rw(my @a, *-0) = 'one'
```
