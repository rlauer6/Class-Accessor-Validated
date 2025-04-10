#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use English qw( -no_match_vars );

{

  package My::Thing;

  use strict;
  use warnings;

  our %ATTRIBUTES = (
    name  => 1,
    color => 0,
  );

  __PACKAGE__->follow_best_practice;
  __PACKAGE__->mk_accessors( keys %ATTRIBUTES );

  use parent 'Class::Accessor::Validated';
}

subtest 'valid construction' => sub {
  my $thing;
  ok(
    eval {
      $thing = My::Thing->new( { name => 'Widget', color => 'blue' } );
      1;
    },
    'constructor succeeds with required and optional keys'
  ) or diag $EVAL_ERROR;

  is( $thing->get_name,  'Widget', 'get_name returns correct value' );
  is( $thing->get_color, 'blue',   'get_color returns correct value' );
};

subtest 'missing required key' => sub {
  ok( !eval { My::Thing->new( { color => 'red' } ); }, 'constructor dies when required key is missing' );
  like( $EVAL_ERROR, qr/required argument\(s\): name/, 'error includes missing key' );
};

subtest 'unexpected key' => sub {
  ok( !eval { My::Thing->new( { name => 'Oops', fluff => 'none' } ); },
    'constructor dies when unknown key is passed' );
  like( $EVAL_ERROR, qr/invalid argument\(s\): fluff/, 'error includes unexpected key' );
};

subtest 'all valid keys' => sub {
  ok(
    eval {
      My::Thing->new( { name => 'Full', color => 'green' } );
      1;
    },
    'constructor accepts all valid keys'
  ) or diag $EVAL_ERROR;
};

done_testing;

1;
