package Lang::Dumb;

use strict;

sub new {
    my $class=shift;
    my $self;
    $self->{"dumb"}=1;
    bless $self,$class;
return $self;
}

sub translate {
  my ($self,$lang,$text)=@_;
return $text;
}

sub clear_cache {
}

sub set_translation {
return 0;
}



1;

=head1 NAME

Lang::Dumb - A backend for Lang internationalization

=head1 SYNOPSIS

  use Lang;

  print _T("This is a test");

  Lang::language("nl");
  
  print _T("This is a test");

=head1 ABSTRACT

This module provides a Dumb backend for the Lang internationalization
module.

=head1 DESCRIPTION

=head2 C<new()> --E<gt> Lang::Dumb

Instantiates a new Lang::Dumb backend.

=head2 C<translate(language,text)> --E<gt> string

Returns 'text'.

=head2 C<clear_cache()> --E<gt> void

Does nothing.


=head1 SEE ALSO

L<Lang|Lang>.

=head1 AUTHOR

Hans Oesterholt-Dijkema <oesterhol@cpan.org>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under LGPL terms.

=cut
