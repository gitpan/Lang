use Lang;
use Lang::SQL;

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
print "\n";


