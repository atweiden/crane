# Crane

<!-- intro {{{ -->

Navigate Perl6 [containers](http://doc.perl6.org/language/containers)
and perform tasks.

<!-- end intro }}} -->


<!-- synopsis {{{ -->

## Synopsis

<!-- example code {{{ -->

```perl6
use Crane;

my %inxi = :info({
    :memory([1564.9, 32140.1]),
    :processes(244),
    :uptime<3:16>
});

%inxi.at(qw<info>)<uptime>:delete;
%inxi.at(qw<info memory>)[0] = 31868.0;

say %inxi.perl; # :info({ :memory(31868.0, 32140.1), :processes(244) });
```

<!-- end example code }}} -->

-------------------------------------------------------------------------------

<!-- end synopsis }}} -->


<!-- description {{{ -->

## Description

Crane aims to be for Perl6 containers what [JSON
Pointer](http://tools.ietf.org/html/rfc6901) and [JSON
Patch](http://tools.ietf.org/html/rfc6902) are for JSON.

### Features

- access nested data structures with JSON Pointer inspired path notation
- get / set values in nested data structures
- diff / patch nested data structures
- list the contents of a nested data structure in accessible format

-------------------------------------------------------------------------------

<!-- end description }}} -->


<!-- exported subroutines {{{ -->

## Exported Subroutines

<!-- at($container,@path) {{{ -->

### `at($container,@path)`

Navigates to and returns container `is rw`.

_arguments:_

* `$container`: _Container, required_ — the target container
* `@path`: _Path, required_ — a list of steps for walking container

_returns:_

* Container at path (`is rw`)

_example:_

```perl6
my %inxi = :info({
    :memory([1564.9, 32140.1]),
    :processes(244),
    :uptime<3:16>
});

at(%inxi, qw<info>)<uptime>:delete;
%inxi.at(qw<info memory>)[0] = 31868.0;

say %inxi.perl; # :info({ :memory(31868.0, 32140.1), :processes(244) });
```

<!-- end at($container,@path) }}} -->

-------------------------------------------------------------------------------

<!-- end exported subroutines }}} -->


<!-- methods {{{ -->

## Methods

<!-- methods toc {{{ -->

- [`.exists($container,@path,:$k,:$v)`](#existscontainerpathkv)
- [`.get($container,@path,:$k,:$v,:$p)`](#getcontainerpathkvp)
- [`.set($container,@path,$value,:$force)`](#setcontainerpathvalueforce)
- [`.move($src,@srcpath,$dest,@destpath,:$v,:$p,:$force)`](#movesrcsrcpathdestdestpathvpforce)
- [`.copy($src,@srcpath,$dest,@destpath,:$v,:$p,:$force)`](#copysrcsrcpathdestdestpathvpforce)
- [`.remove($container,@path,:$v,:$p,:$force)`](#removecontainerpathvpforce)
- [`.list($container,@path)`](#listcontainerpath)
- [`.flatten($container,@path)`](#flattencontainerpath)
- [`.transform($container,@path,$block)`](#transformcontainerpathblock)

<!-- end methods toc }}} -->

<!-- example data structure {{{ -->

All example code assumes `%data` has this structure:

```perl6
my %data =
    :legumes([
        {
            :instock(4),
            :name("pinto beans"),
            :unit("lbs")
        },
        {
            :instock(21),
            :name("lima beans"),
            :unit("lbs")
        },
        {
            :instock(13),
            :name("black eyed peas"),
            :unit("lbs")
        },
        {
            :instock(8),
            :name("split peas"),
            :unit("lbs")
        }
    ]);
```

<!-- end example data structure }}} -->

<!-- .exists($container,@path,:$k,:$v) {{{ -->

### `.exists($container,@path,:$k,:$v)`

Determines whether a key exists in the container at the
specified path. Works similar to the p6 Hash `:exists` [subscript
adverb](http://doc.perl6.org/type/Hash#%3Aexists). Pass the `:v` flag to
determine whether a defined value is paired to the key at the specified
path.

_arguments:_

* `$container`: _Container, required_ — the target container
* `@path`: _Path, required_ — a list of steps for walking container
* `:$k`: _Bool, optional, defaults to True_ — indicates whether to
         check for a defined key at path
* `:$v`: _Bool, optional_ — indicates whether to check for a defined
         value at path

_returns:_

* `True` if defined or `False` if undefined

_What about operating on the root of the container?_

Pass an empty list as `@path` to operate on the root of the container.

- if `:v` flag passed: test `if $container`
- if `:k` flag passed (the default): raise error "Sorry, not possible
                                     to request key operations on the
                                     container root"

<!-- end .exists($container,@path,:$k,:$v) }}} -->

<!-- .get($container,@path,:$k,:$v,:$p) {{{ -->

### `.get($container,@path,:$k,:$v,:$p)`

Gets the value from container at the specified path. The default
behavior is to raise an error if path is nonexistent.

_arguments:_

* `$container`: _Container, required_ — the target container
* `@path`: _Path, required_ — a list of steps for walking container
* `:$k`: _Bool, optional_ — only return the key at path
* `:$v`: _Bool, optional, defaults to True_ — only return the value
         at path
* `:$p`: _Bool, optional_ — return the key-value pair at path

_returns:_

* the dereferenced key, value or key-value pair

_example:_

```perl6
my $value = Crane.get(%data, ['legumes', 1]);
say $value.perl; # { :instock(21), :name("lima beans"), :unit("lbs") }

my $value-k = Crane.get(%data, ['legumes', 1], :k);
say $value-k.perl; # 1

my $value-p = Crane.get(%data, ['legumes', 1], :p);
say $value-p.perl; # 1 => { :instock(21), :name("lima beans"), :unit("lbs") }
```

_What about operating on the root of the container?_

Pass an empty list as `@path` to operate on the root of the container.

- if `:v` flag passed (the default): `return $container`
- if `:k` flag passed: raise error "Sorry, not possible to request key
                       operations on the container root"
- if `:p` flag passed: raise error "Sorry, not possible to request key
                       operations on the container root"

<!-- end .get($container,@path,:$k,:$v,:$p) }}} -->

<!-- .set($container,@path,$value,:$force) {{{ -->

### `.set($container,@path,$value,:$force)`

Sets the `value` at the specified path in the container. The default
behavior is to raise an error if a value at path exists.

_arguments:_

* `$container`: _Container, required_ — the target container
* `@path`: _Path, required_ — a list of steps for navigating container
* `$value`: _Any_ — the value to be set at the specified path
* `:$force`: _Bool, optional_ — indicates whether pre-existing values
             at path are overwritten during the call

_returns:_

* The prior value at the container's path — therefore, `Any` means
  the path was nonexistent.

_example:_

```perl6
my %peters;

my $prior1 = Crane.set(%peters, qw<peter piper>, 'man');
my $prior2 = Crane.set(%peters, qw<peter pan>, 'boy');
my $prior3 = Crane.set(%peters, qw<peter pickle>, 'dunno');

say $prior1; # (Any)
say $prior2; # (Any)
say $prior3; # (Any)
say %peters.perl; # { :peter({ :pan("boy"), :pickle("dunno"), :piper("man") }) }
```

example force:

```perl6
my $prior = Crane.set(%data, ['legumes', 1, 'instock'], 50, :force);
say $prior.perl; # 21
```

_What about operating on the root of the container?_

Pass an empty list as `@path` to operate on the root of the container.

- if value assignment (`=`) to `$container` fails, raise error and
  propogate the original error message
  - value assignment will fail when assigning a List to a `$container`
    of type Hash and vice versa
- overwrite existing values if `:force` flag is passed

```perl6
my $a = (1, 2, 3);
my $prior = Crane.set($a, [], "foo", :force);
say $prior.perl; $(1, 2, 3)
say $a.perl; # "foo"
```

<!-- end .set($container,@path,$value,:$force) }}} -->

<!-- .move($src,@srcpath,$dest,@destpath,:$v,:$p,:$force) {{{ -->

### `.move($src,@srcpath,$dest,@destpath,:$v,:$p,:$force)`

Moves the source value identified by `@srcpath` in `$src` container to
`$dest` destination container at location specified by `@destpath`.

The default behavior is to raise an error if the source and destination
locations are the same.

The default behavior is to raise an error if the source is nonexistent.

The default behavior is to raise an error if the destination has an
existing value unless the `:force` flag is present.

Use of the `:force` flag does not guarantee the operation will
succeed, e.g. in the case of attempting to reassign [immutable
values](http://doc.perl6.org/language/containers).

The default behavior is to move only the value from the source container
path unless the `:p` flag is present.

If the source is of type `Associative` and the `:p` flag is not present,
the default behavior is to move the source value to the destination,
resetting the source value to `Any`.

If the source is of type `Associative`, and the `:p` flag is present,
the key-value pair at the source is moved to the destination.

If the source is of type `Positional` and the `:p` flag is not present,
the default behavior is to move the source value to the destination,
resetting the source value to `Any`.

If the source is of type `Positional` and the `:p` flag is present, the
default behavior is to move the positional index (`Int`) as the key with
its associated value to the destination, splicing it out from the source.

_arguments:_

* `$src`: _Container, required_ — the source container
* `@srcpath`: _Path, required_ — a list of steps to the source
* `$dest`: _Container, required_ — the destination container
* `@destpath`: _Path, required_ — a list of steps to the destination
* `:$v`: _Bool, optional, defaults to True_ — only move the source value
* `:$p`: _Bool, optional_ — move the source key-value pair
* `:$force`: _Bool, optional_ — indicates whether pre-existing values
             at path are overwritten during the call

_returns:_

* The prior value at the destination's path — therefore, `Any` means
  the destination's path was nonexistent.

_What about operating on the root of the container?_

Pass an empty list as path to operate on the root of the container.

- if value assignment (`=`) to `$container` fails, abort move operation,
  raise error and propogate the original error message
  - value assignment will fail when assigning a List to a `$container`
    of type Hash and vice versa
- overwrite existing values if `:force` flag is passed

```perl6
my $a = (1, 2, 3);
my $b = (4, 5, 6);
my $prior-b = Crane.move($a, [], $b, [], :force);
say $prior-b.perl; # $(4, 5, 6)
say $b.perl; # $(1, 2, 3)
say $a.perl; # Any

my $c;
my $prior-c = Crane.move($b, [], $c, []);
say $prior-c.perl; # Any
say $c.perl; # $(1, 2, 3)
say $b.perl; # Any
say $a.perl; # Any
```

<!-- end .move($src,@srcpath,$dest,@destpath,:$v,:$p,:$force) }}} -->

<!-- .copy($src,@srcpath,$dest,@destpath,:$v,:$p,:$force) {{{ -->

### `.copy($src,@srcpath,$dest,@destpath,:$v,:$p,:$force)`

Copies the source value identified by `@srcpath` in `$src` container to
`$dest` destination container at location specified by `@destpath`.

The default behavior is to raise an error if the source and destination
locations are the same.

The default behavior is to raise an error if the source is nonexistent.

The default behavior is to raise an error if the destination has an
existing value unless the `:force` flag is present.

If the source is of type `Associative` and the `:p` flag is not present,
the default behavior is to copy the source value to the destination.

If the source is of type `Associative`, and the `:p` flag is present,
the key-value pair at the source is copied to the destination.

If the source is of type `Positional` and the `:p` flag is not present,
the default behavior is to copy the source value to the destination.

If the source is of type `Positional` and the `:p` flag is present,
the default behavior is to copy the positional index (`Int`) as the key
with its associated value to the destination.

_arguments:_

* `$src`: _Container, required_ — the source container
* `@srcpath`: _Path, required_ — a list of steps to the source
* `$dest`: _Container, required_ — the destination container
* `@destpath`: _Path, required_ — a list of steps to the destination
* `:$v`: _Bool, optional, defaults to True_ — only copy the source value
* `:$p`: _Bool, optional_ — copy the source key-value pair
* `:$force`: _Bool, optional_ — indicates whether pre-existing values
             at path are overwritten during the call

_returns:_

* The prior value at the destination's path — therefore, `Any` means
  the destination's path was nonexistent.

_example:_

```perl6
my %h = :example<hello>;
my $prior = Crane.copy(%h, qw<example>, %h, qw<sample>);
say %h.perl # { :example("hello"), :sample("hello") }
say $prior # (Any);
```

_What about operating on the root of the container?_

Pass an empty list as path to operate on the root of the container. Has
similar rules / considerations to `.move`.

<!-- end .copy($src,@srcpath,$dest,@destpath,:$v,:$p,:$force) }}} -->

<!-- .remove($container,@path,:$v,:$p,:$force) {{{ -->

### `.remove($container,@path,:$v,:$p,:$force)`

Removes the pair at path from `Associative`
types, similar to the p6 Hash `:delete` [subscript
adverb](http://doc.perl6.org/type/Hash#%3Adelete). Splices elements out
from `Positional` types.

Removes only the value at path from `Associative` types if the `:v`
flag is passed, resetting the value to `Any`. Resets `Positional` type
elements to `Any` if the `:v` flag is passed.

The default behavior is to raise an error if path is nonexistent.

_arguments:_

* `$container`: _Container, required_ — the target container
* `@path`: _Path, required_ — a list of steps for walking container
* `:$v`: _Bool, optional_ — only remove the value at path (reset to `Any`)
* `:$p`: _Bool, defaults to True_ — remove the key-value pair at path
* `:$force`: _Bool, optional_ — ignore nonexistent paths

_returns:_

* The prior value at the container's path

_example:_

```perl6
my %h = :example<hello>;
my $prior = Crane.remove(%h, qw<example>);
say %h.perl; # {}
say $prior.perl; # "hello"
```

This:

```perl6
%h<a><b>:delete;
```

is equivalent to this:

```perl6
Crane.remove(%h, qw<a b>);
```

_What about operating on the root of the container?_

Pass an empty list as path to operate on the root of the container.

```perl6
my $a = (1, 2, 3);
my $prior = Crane.remove($a, []);
say $prior.perl; $(1, 2, 3)
say $a; # (Any)
```

<!-- end .remove($container,@path,:$v,:$p,:$force) }}} -->

<!-- .list($container,@path) {{{ -->

### `.list($container,@path)`

Lists all of the paths available in container.

_arguments:_

* `$container` : _Container, required_ — the target container
* `@path`: _Path, optional_ — a list of steps for navigating container

_returns:_

* array of path:value hashes

_example:_

Listing a `Hash`:

```perl6
say Crane.list(%data);
[
    # ...
    {
        :path('legumes', 2, 'unit'),
        :value<ea>
    },
    {
        :path('legumes', 2, 'instock'),
        :value(9340)
    },
    {
        :path('legumes', 3, 'name'),
        :value<split peas>
    },
    {
        :path('legumes', 3, 'unit'),
        :value<lbs>
    },
    {
        :path('legumes', 3, 'instock'),
        :value(8)
    }
]
```

Listing a list:

```perl6
my $a = qw<zero one two>;
say Crane.list($a);
[
    {
        :path(0),
        :value("zero")
    },
    {
        :path(1),
        :value("one")
    },
    {
        :path(2),
        :value("two")
    }
]
```

<!-- end .list($container,@path) }}} -->

<!-- .flatten($container,@path) {{{ -->

### `.flatten($container,@path)`

Flattens a container into a single-level `Hash` of path-value pairs.

_arguments:_

* `$container` : _Container, required_ — the target container
* `@path`: _Path, optional_ — a list of steps for navigating container

_returns:_

* a flattened `Hash` of path-value pairs.

_example:_

```perl6
say Crane.flatten(%data);
{
    # ...
    ['legumes', 1, 'name']    => "lima beans",
    ['legumes', 1, 'unit']    => "lbs",
    ['legumes', 1, 'instock'] => 21,
    ['legumes', 2, 'name']    => "black eyed peas",
    ['legumes', 2, 'unit']    => "ea",
    ['legumes', 2, 'instock'] => 9340,
    ['legumes', 3, 'name']    => "split peas",
    ['legumes', 3, 'unit']    => "lbs",
    ['legumes', 3, 'instock'] => 8
}
```

<!-- end .flatten($container,@path) }}} -->

<!-- .transform($container,@path,$block) {{{ -->

### `.transform($container,@path,$block)`

_example:_

```perl6
my %market =
    :foods({
        :fruits(qw<blueberries marionberries>),
        :veggies(qw<collards onions>)
    });

my @first-fruit = |qw<foods fruits>, 0;
my @second-veggie = qw<foods veggies>, 1;

my &oh-yeah = -> $s { say $s ~ '!' };

Crane.transform(%market, @first-fruit, &oh-yeah);
say so Crane.get(%market, @first-fruit) eq 'blueberries!'; # True

Crane.transform(%market, @second-veggie, &oh-yeah);
say so Crane.get(%market, @second-veggie) eq 'onions!'; # True
```

<!-- end .transform($container,@path,$block) }}} -->

-------------------------------------------------------------------------------

<!-- end methods }}} -->


<!-- classes {{{ -->

## Classes

<!-- classes toc {{{ -->

- [`Crane` Class](#crane-class)

<!-- end classes toc }}} -->

<!-- Crane Class {{{ -->

### `Crane` Class

Encapsulates container related operations for a specified path.

<!-- Crane Class attributes {{{ -->

#### attributes:

* `.path` : _Path_ — contains the `Crane`'s list of steps for walking
            a container

<!-- end Crane Class attributes }}} -->

<!-- Crane Class methods {{{ -->

#### methods:

<!-- .new(@path) {{{ -->

##### `.new(@path)`

Instantiates `Crane` class.

_arguments:_

* `@path` : _Path, required_ — a list of steps for walking a container

_returns:_

* a new `Crane` instance

_example:_

```perl6
my $crane = Crane.new('legumes', 0);
```

<!-- end .new(@path) }}} -->

`Crane` classes get access to all methods documented above, with
the stipulation that the path to the source container is the `Crane`
instance's `.path` attribute.

<!-- end Crane Class methods }}} -->

<!-- end Crane Class }}} -->

-------------------------------------------------------------------------------

<!-- end classes }}} -->


<!-- licensing {{{ -->

## Licensing

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.

<!-- licensing }}} -->

<!-- vim: ft=markdown fdm=marker fdl=0 -->
