# NAME

Class::Accessor::Validated - A drop-in companion for
Class::Accessor::Fast with constructor validation

# SYNOPSIS

    package My::Thing;

    use strict;
    use warnings;

    our %ATTRIBUTES = (
        name    => 1,  # required
        color   => 0,  # optional
        enabled => 0,
    );

    __PACKAGE__->follow_best_practice;
    __PACKAGE__->mk_accessors( keys %ATTRIBUTES );

    use parent qw(Class::Accessor::Validated Class::Accessor::Fast);

    package main;

    my $thing = My::Thing->new({
        name    => 'widget',
        enabled => 1,
    });

# DESCRIPTION

`Class::Accessor::Validated` is a simple companion to
[Class::Accessor::Fast](https://metacpan.org/pod/Class%3A%3AAccessor%3A%3AFast) that adds lightweight validation to your
object constructors. If you've ever passed in an option to your class
and wondered why it wasn't being respected it might have been because
the class didn't take that option in the first place! This class will
at least prevent you from passing in unimplemented options.

It is intended to be used as a subclass:

    use parent qw(Class::Accessor::Validated);

It checks that only known attributes are passed to `new()`, and it
enforces required attributes based on a hash your class must define:

    our %ATTRIBUTES = (
        foo => 1,   # required
        bar => 0,   # optional
    );

Any attribute with a true value is considered required. The rest are
optional.  If unknown keys are passed, or required keys are missing,
the constructor will `die()` with a descriptive error message.

# USAGE

To use `Class::Accessor::Validated`, your class must:

- Declare a `%ATTRIBUTES` package variable that lists all valid
constructor parameters.
- Inherit from `Class::Accessor::Validated`.
- Call `mk_accessors(keys %ATTRIBUTES)` to generate accessors.

No additional methods are exported or injected - only the constructor
is affected.

# METHODS AND SUBROUTINES

## new

    my $object = My::Class->new(\%params);

Validates the constructor arguments against your class's
`%ATTRIBUTES` hash.

Dies with a detailed message if:

- Any invalid keys are passed
- Any required keys are missing

Otherwise, it delegates to `SUPER::new()` and returns the constructed
object.

_One small improvement(?) is that you may pass either a list of
key/value pairs or a hash reference to the constrcutor._

# SEE ALSO

[Class::Accessor::Fast](https://metacpan.org/pod/Class%3A%3AAccessor%3A%3AFast), [Class::Accessor](https://metacpan.org/pod/Class%3A%3AAccessor)

# AUTHOR

Rob Lauer

# LICENSE

This module is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.
