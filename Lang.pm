package Lang;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

@EXPORT = qw(_T);

my $backend;
my $language="english";

sub init {
  my $lang_backend=shift;
  $backend=$lang_backend;
}

sub _T {
  my $text=shift;
return $backend->translate($language,$text);
}

sub language {
  my $l=shift;
  $language=$l;
}


1;
__END__

=head1 NAME

Lang - A module for internationalization

=head1 SYNOPSIS

  use Lang;
  use Lang::SQL;
  
  Lang::init(new Lang::SQL("dbi:Pg:dbname=zclass;host=localhost","test","testpass");
  
  Lang::language("english");

  print _T("This is a test");

  Lang::language("dutch");
  
  print _T("This is a test");

=head1 ABSTRACT

This module provides simple string based internationalization support. It
exports a '_T' function that can be used for all text that need displayed.
It can work with different backends, e.g. SQL or file based backends. 

=head1 DESCRIPTION

With this module simple string based internationalization can be made through
uses of '_T' function calls. Strings will be looked up by a backend and B<can>
be subsequentially cached by the same backend. For an interface to the backend
see L<Lang::SQL|Lang::SQL>.

=head2 C<Lang::init(backend)> --E<gt> void

This initializes the Lang module with a supported backend. This function
must be called B<before> B<any> use of the _T() function.

=head2 C<Lang::language(language)> --E<gt> void

This sets the current language to use. Languages are free to be named, but
it is recommended to use common categories as provided in ISO639, e.g. 'en',
'nl', 'no', 'pl', etc. The language is default initialized to 'en' (for category
english).

If language is set to "" (empty string), no translations must be done
by function _T().

=head2 C<_T(text)> --E<gt> string

This function looks up 'text' in the current backend and returns a translation
for 'text' given the provided language. 

This function actually B<only> calls the backend function 
C<backend->translate($language,$text)>; nothing else. The backend
must to solve the rest.

=head2 EXPORT

_T() is exported.

=head1 SEE ALSO

L<Lang::SQL|Lang::SQL>, ISO639 (google works).

=head1 AUTHOR

Hans Oesterholt-Dijkema <oesterhol@cpan.org>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under LGPL terms.

=cut
