package Lang::SQL;

use strict;
use DBI;
use DBI::Const::GetInfoType;

my %cache;

sub new {
  my $class=shift;
  my $dsn=shift;
  my $user=shift;
  my $pass=shift;
  my $self;

  $self->{"dsn"}=$dsn;
  $self->{"dbh"}=DBI->connect($dsn,$user,$pass);
  $self->{"status"}="none";

  bless $self,$class;

  { # Check existence

    my $sth=$self->{"dbh"}->prepare("SELECT COUNT(txt) FROM lang_translations");
    my $dbh=$self->{"dbh"};

    if (not $sth->execute()) {
      $sth->finish();

      my $driver=lc($dbh->{Driver}->{Name});

      if ($driver eq "pg") {
	$self->{"dbh"}->do("CREATE TABLE lang_translations (txt varchar, lang varchar(32), translation varchar, translated numeric(1))");
	$self->{"dbh"}->do("CREATE INDEX lang_translations_idx ON lang_translations(lang,txt)");
      }
      elsif ($driver eq "mysql") {
	$self->{"dbh"}->do("CREATE TABLE lang_translations (txt text, lang varchar(32), translation text, translated numeric(1))");
	$self->{"dbh"}->do("CREATE INDEX lang_translations_idx ON lang_translations(lang,txt)");
      }
      elsif ($driver eq "sqlite") {
	$self->{"dbh"}->do("CREATE TABLE lang_translations (txt text, lang varchar(32), translation text, translated numeric(1))");
	$self->{"dbh"}->do("CREATE INDEX lang_translations_idx ON lang_translations(lang,txt)");
      }
      else {
	die "Cannot create  table lang_translations (txt varchar(BIG), lang varchar(32), translation varchar(big),translated numeric(1))\n".
	    "I don't know this database system '$driver'";
      }
    }
    else {
      $sth->finish();
    }
  }

return $self;
}

sub DESTROY {
  my $self=shift;
  $self->{"dbh"}->disconnect();
}

sub translate {
  my $self=shift;
  my $lang=shift;
  my $text=shift;

  my $dbh=$self->{"dbh"};

  if ($lang eq "") { return $text; }
  else {
    if (exists $cache{"$lang && $text"}) { 
      return $cache{"$lang && $text"};
    }
    else {
      my $sth=$dbh->prepare("SELECT translation FROM lang_translations WHERE txt='$text' AND lang='$lang'");
      $sth->execute();
      if ($sth->rows() gt 0) {
	my @r=$sth->fetchrow_array();
	$cache{"$lang && $text"}=shift @r;
	$sth->finish();
	return $self->translate($lang,$text);
      }
      else {
	$cache{"$lang && $text"}=$text;
	$sth->finish();
	$dbh->do("INSERT INTO lang_translations (translation, lang, txt, translated) VALUES ('$text','$lang','$text',0)");
	return $self->translate($lang,$text);
      }
    }
  }
}

sub clear_cache {
    %cache = ();
}

sub set_translation {
  my $self=shift;
  my $lang=shift;
  my $text=shift;
  my $translation=shift;

  if ($lang eq "") {
    die "Cannot set a translation for an empty language";
  }

  my $dbh=$self->{"dbh"};

  my $sth=$dbh->prepare("SELECT translation FROM lang_translations WHERE txt='$text' AND lang='$lang'");
  $sth->execute();
  if ($sth->rows() gt 0) {
    $sth->finish();
    $dbh->do("UPDATE lang_translations SET translation='$translation', translated=1 WHERE txt='$text' AND lang='$lang'");
  }
  else {
    $sth->finish();
    $dbh->do("INSERT INTO lang_translations (translation, lang, txt, translated) VALUES ('$text','$lang','$text',0)");
  }

  $cache{"$lang && $text"}=$translation;

return 1;
}

1;

__END__

=head1 NAME

Lang::SQL - A backend for Lang internationalization

=head1 SYNOPSIS

  use Lang;
  use Lang::SQL;
  
  Lang::init(new Lang::SQL("dbi:Pg:dbname=zclass;host=localhost","test","testpass");
  
  Lang::language("en");

  print _T("This is a test");

  Lang::language("nl");
  
  print _T("This is a test");

=head1 ABSTRACT

This module provides an SQL backend for the Lang internationalization
module.

=head1 DESCRIPTION

=head2 C<new(dsn,user,pass)> --E<gt> Lang::SQL

Instantiates a new backend object with given DSN, user and password.
It creates, if not already existent, table 'lang_translations' and 
index 'lang_translations_idx' in the given database in DSN.

=head2 C<translate(language,text)> --E<gt> string

This function looks up a translation for the tuple (language, text)
in the database. If it doesn't find one, it inserts the tuple in
the database with translation 'text'. 

This function will cache all lookups in the database. So after a running
a program for a while, there won't be a lot of database access anymore 
for translations. This also means, that a updating translations in the
database will probably not result in updated translations in the application.

=head2 C<set_translation(language,text,translation)> --E<gt> boolean

This function looks up the tuple (language,text) in the database.
If it does exist, it updates the translation for this field. 
Otherwise, it inserts the translation.

This function will cache the translation. Function always returns C<true>
(i.e. 1).

=head2 C<clear_cache()> --E<gt> void

This function will clear the cache of translations.

=head1 BUGS

This module has only been tested with PostgreSQL.

=head1 SEE ALSO

L<Lang|Lang>.

=head1 AUTHOR

Hans Oesterholt-Dijkema <oesterhol@cpan.org>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under LGPL terms.

=cut
