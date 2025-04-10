#-*- mode: makefile; -*-

PERL_MODULES = \
    lib/Class/Accessor/Validated.pm

VERSION := $(shell perl -I lib -MClass::Accessor::Validated -e 'print $$BLM::Startup::$(MODULE)::VERSION;')

TARBALL = Class-Accessor-Validated-$(VERSION).tar.gz

$(TARBALL): buildspec.yml $(PERL_MODULES) requires test-requires README.md
	make-cpan-dist.pl -b $<

README.md: lib/Class/Accessor/Validated.pm
	pod2markdown $< > $@

clean:
	rm -f *.tar.gz
