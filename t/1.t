# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { 
	use_ok('Lang');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

### Lang::Dumb testing

ok(_T("This is a test") eq "This is a test","Lang default - Lang with Lang::Dumb backend");

### Set language

Lang::language("nl");
ok(_T("This is a test") eq "This is a test","Lang default - Lang with Lang::Dumb backend");

### Set translation and reread translation

Lang::language("nl");
ok((not Lang::set_translation("This is a test","Dit is een test")),"Lang default - Lang with Lang::Dumb backend");

Lang::clear_cache();
ok(_T("This is a test") eq "This is a test","Lang default - Lang with Lang::Dumb backend");

