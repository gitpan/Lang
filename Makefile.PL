use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Lang',
    'VERSION_FROM'	=> 'Lang.pm', # finds $VERSION
    'PREREQ_PM'		=> { DBI => 1.3, Wx => 0.18 }, 
    'ABSTRACT_FROM'     => 'Lang.pm', # retrieve abstract from module
    'AUTHOR'            => 'Hans Oesterholt-Dijkema <oesterhol@cpan.org>',
);
