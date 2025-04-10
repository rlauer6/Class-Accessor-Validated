# NAME

Class::Accessor::Validated - Drop-in constructor validation for
Class::Accessor::Fast-based classes

# VERSION

Version 0.04

# SYNOPSIS

    package MyApp::Thing;

    use parent 'Class::Accessor::Validated';

    our %ATTRIBUTES = (
        id   => 1,    # required
        name => 0,    # optional
    );

    __PACKAGE__->setup_accessors(keys %ATTRIBUTES);

    # Then in code:
    my $thing = MyApp::Thing->new({ id => 123 });

# DESCRIPTION

`Class::Accessor::Validated` extends [Class::Accessor::Fast](https://metacpan.org/pod/Class%3A%3AAccessor%3A%3AFast) to add
lightweight constructor-time validation for required and unexpected
arguments.

It supports the same hashref-based constructor pattern, and requires
you to define a `%ATTRIBUTES` hash in your class (or inherited from a
parent class) to indicate which keys are required. Any key passed to
the constructor must correspond to an existing accessor.

This module is designed to be a minimal and backward-compatible
validator that requires no additional dependencies or heavy OO layers.

# ADDITIONAL DETAILS

This module can also be used immediately in new subclasses, even when
the parent class does not itself inherit from
`Class::Accessor::Validated`. As long as the subclass defines a
`%ATTRIBUTES` hash and installs its accessors using setup\_accessors,
the constructor validation will function correctly. This makes it
possible to incrementally adopt validation in an existing hierarchy
without modifying base classes - a practical solution for modernizing
older code or introducing stricter argument checking in new layers of
functionality.

Even in the absence of a `%ATTRIBUTES hash`, the constructor will
still validate all arguments against the set of defined accessors. Any
option that does not correspond to known accessors (either get\_foo and
set\_foo or just foo) will be flagged as invalid. 

**You are encouraged to `follow_best_practice` since methods that are
not named `set_` or `get_` may be mistaken for accessors.**

However, any option that does match a known accessor but is not listed
in `%ATTRIBUTES` will be assumed to be optional. This allows
subclasses to define additional accessors without needing to
explicitly extend `%ATTRIBUTES`, and enables gradual adoption in
codebases where base classes are not yet updated for validation.

# METHODS AND SUBROUTINES

## new

    my $obj = My::Class->new({ foo => 1, bar => 2 });

The constructor performs the following checks:

- Any key passed must match an existing accessor (`get_foo`, `foo`,
etc.)
- If a key is listed in `%ATTRIBUTES` with a true value, it is
considered required
- Keys not in `%ATTRIBUTES` are assumed optional as long as accessors
exist
- If invalid or missing keys are detected, the constructor throws an
error

## setup\_accessors

    Class::Accessor::Validated->setup_accessors(__PACKAGE__, @keys);

Convenience method to install accessors and apply
`follow_best_practice` for the calling package. This avoids having to
explicitly `use Class::Accessor` in each class.

# GLOBAL VARIABLES

## $Class::Accessor::Validated::ALLOW\_BAD\_PRACTICE

If set to a true value, constructor validation will accept any method
name (e.g., `foo`) as a valid accessor, even if it does not follow
the `get_foo`/`set_foo` naming pattern. This is useful for backward
compatibility with older `Class::Accessor::Fast` code.

Defaults to false. Best practice is to use `follow_best_practice` so
that accessors are unambiguously named and validated.

# USAGE PATTERN

To use this module:

- Inherit from `Class::Accessor::Validated`
- Declare a `%ATTRIBUTES` hash in your package
- Call `setup_accessors()` with the list of keys

Subclasses do not need to redefine `%ATTRIBUTES` unless they want to
introduce new required keys.

# SEE ALSO

[Class::Accessor](https://metacpan.org/pod/Class%3A%3AAccessor), [Class::Accessor::Fast](https://metacpan.org/pod/Class%3A%3AAccessor%3A%3AFast)

# AUTHOR

Rob Lauer

# LICENSE

This module is released under the same terms as Perl itself.
