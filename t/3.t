# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
BEGIN { 
	use_ok('Lang');
	use_ok('Lang::SQL');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

### Lang::wxLocale testing

my $DSN=$ENV{"DSN"} or die "You need to specify a DSN to run this test";
my $DBUSER=$ENV{"DBUSER"} or die "You need to specify a DBUSER to run this test";
my $DBPASS=$ENV{"DBPASS"};

Lang::init(new Lang::SQL($DSN,$DBUSER,$DBPASS));

ok(_T("This is a test") eq "This is a test","Lang with Lang::SQL backend");

### Set language

Lang::language("nl");
ok(_T("This is a test") eq "Dit is een test","Lang with Lang::SQL backend");

### Set translation and reread translation

Lang::language("de");
ok((Lang::set_translation("This is a test","Dies ist ein test")),"Lang with Lang::SQL backend");

Lang::language("nl");
ok((Lang::set_translation("This is a test","Dit is een test")),"Lang with Lang::SQL backend");
Lang::clear_cache();
print _T("This is a test"),"\n";
ok(_T("This is a test") eq "Dit is een test","Lang with Lang::SQL backend");



