# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 6;
BEGIN { 
	use_ok('Lang');
	use_ok('Lang::wxLocale');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

### Lang::wxLocale testing

Lang::init(new Lang::wxLocale("./locale","default"));

ok(_T("This is a test") eq "This is a test","Lang with Lang::wxLocale backend");

### Set language

Lang::language("nl");
ok(_T("This is a test") eq "Dit is een test","Lang with Lang::wxLocale backend");

### Set translation and reread translation

Lang::language("de");
ok((not Lang::set_translation("This is a test","Dies ist ein test")),"Lang with Lang::wxLocale backend");

Lang::language("nl");
Lang::clear_cache();
print _T("This is a test"),"\n";
ok(_T("This is a test") eq "Dit is een test","Lang with Lang::wxLocale backend");



