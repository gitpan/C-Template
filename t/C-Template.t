use warnings;
use strict;
use Test::More tests => 3;
BEGIN { use_ok('C::Template') };
use C::Template;

my %vars;
$vars{test} = <<EOF;
This is a "dandy" young dog-a-roon.
He likes a tickle-baby-oh.
EOF

my $x = <<EOF;
[% test | c %]
EOF

my $template = C::Template->new ();
$template->process (\$x, \%vars, \my $out);
#print $out;
ok ($out =~ /".*\\"dandy\\".*\\n"/, "C filter test 1");

$template->process ('template-1', \%vars, \my $out2);
print "$out2\n";
ok ($out2 =~ /#line 5/, "Addition of line numbers OK");
# Local variables:
# mode: perl
# End:

