use Lang;
use DBI;
use Lang::SQL;

# Language in dumb mode will give back what it gets.

print "\n";
print _T("This won't be translated.\n");
print _T("Dit zal niet worden vertaald.\n");
print "\n";

# Now initialize the SQL backend. 
# If you update the table in the SQL server
# and alter different translations for 'nl', you'll
# find an other text for language 'nl'.

my $IDIDIT=0;
my $DSN="dbi:Pg:dbname=zclass;host=localhost";
my $USER="zclass";
my $PASS="";

if (not $IDIDIT) {
    print "\n";
    print "\n";
    print "***************************************************\n";
    print "NB! You may need to enter proper values for\n";
    print "\$DSN, \$USER and \$PASS for this test to work!\n";
    print "Set \$IDIDIT to 1, after you set them to the right\n";
    print "values.\n";
    print "***************************************************\n";
    print "\n";
    print "continuing test...\n";
    print "\n";
    print "\n";
}

Lang::init(new Lang::SQL($DSN,$USER,$PASS));

print _T("This is a text"),"\n";
print "\n";

Lang::language("nl");
print _T("This is a text"),"\n";

my $dbh=DBI->connect($DSN,$USER,$PASS);
print "You'll see our pid ($$) in this translation\n";
$dbh->do("UPDATE lang_translations SET translation='Dit is een tekst ($$)' WHERE text='This is a text' AND lang='nl'");
$dbh->disconnect();

Lang::clear_cache();

print _T("This is a text"),"\n";
print "\n";


