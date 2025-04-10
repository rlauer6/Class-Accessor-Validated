package Class::Accessor::Validated;

use strict;
use warnings;

use Data::Dumper;
use Class::Accessor::Fast;

__PACKAGE__->follow_best_practice;
use parent qw(Class::Accessor::Fast);

our $VERSION = '0.01';

########################################################################
sub new {
########################################################################
  my ( $class, @args ) = @_;

  my $sym = $class . '::ATTRIBUTES';

  no strict 'refs';

  die "$class must define \%ATTRIBUTES\n"
    if !defined *{$sym}{HASH};

  my %attributes = %{ *{$sym}{HASH} };

  my $options = ref $args[0] ? $args[0] : {@args};

  my @invalid_args = grep { !exists $attributes{$_} } keys %{$options};

  my @errors;

  if (@invalid_args) {
    push @errors, sprintf "invalid argument(s): %s\n", join q{,}, @invalid_args;
  }

  my @required = grep { $attributes{$_} } keys %attributes;

  my @required_args = grep { !exists $options->{$_} } @required;

  if (@required_args) {
    push @errors, sprintf "required argument(s): %s\n", join q{,}, @required_args;
  }

  die @errors
    if @errors;

  my $self = $class->SUPER::new($options);

  return $self;
}

1;

__END__

=pod

=head1 NAME

Class::Accessor::Validated - A drop-in companion for
Class::Accessor::Fast with constructor validation

=head1 SYNOPSIS

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

=head1 DESCRIPTION

C<Class::Accessor::Validated> is a simple companion to
L<Class::Accessor::Fast> that adds lightweight validation to your
object constructors. If you've ever passed in an option to your class
and wondered why it wasn't being respected it might have been because
the class didn't take that option in the first place! This class will
at least prevent you from passing in unimplemented options.

It is intended to be used as a subclass:

 use parent qw(Class::Accessor::Validated);

It checks that only known attributes are passed to C<new()>, and it
enforces required attributes based on a hash your class must define:

 our %ATTRIBUTES = (
     foo => 1,   # required
     bar => 0,   # optional
 );

Any attribute with a true value is considered required. The rest are
optional.  If unknown keys are passed, or required keys are missing,
the constructor will C<die()> with a descriptive error message.

=head1 USAGE

To use C<Class::Accessor::Validated>, your class must:

=over 4

=item *

Declare a C<%ATTRIBUTES> package variable that lists all valid
constructor parameters.

=item *

Inherit from C<Class::Accessor::Validated>.

=item *

Call C<mk_accessors(keys %ATTRIBUTES)> to generate accessors.

=back

No additional methods are exported or injected - only the constructor
is affected.

=head1 METHODS AND SUBROUTINES

=head2 new

 my $object = My::Class->new(\%params);

Validates the constructor arguments against your class's
C<%ATTRIBUTES> hash.

Dies with a detailed message if:

=over 4

=item *

Any invalid keys are passed

=item *

Any required keys are missing

=back

Otherwise, it delegates to C<SUPER::new()> and returns the constructed
object.

I<One small improvement(?) is that you may pass either a list of
key/value pairs or a hash reference to the constrcutor.>

=head1 SEE ALSO

L<Class::Accessor::Fast>, L<Class::Accessor>

=head1 AUTHOR

Rob Lauer

=head1 LICENSE

This module is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
