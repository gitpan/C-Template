use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/C/Template.pm';
my $repo = 'https://github.com/benkasminbullock/C-Template';

WriteMakefile (
    NAME => 'C::Template',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
        'C::Utility' => '0.001',
        'Template' => '0',
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    # There is a fail for Perl 5.6.2 on Cpan testers.
    MIN_PERL_VERSION => '5.008001',
);
