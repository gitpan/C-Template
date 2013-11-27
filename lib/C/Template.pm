package C::Template;
use warnings;
use strict;
our $VERSION = 0.03;

use Template;
use Template::Filters;
use Carp;
use C::Utility qw/convert_to_c_string convert_to_c_string_pc add_lines/;
use FindBin;

my $filters = Template::Filters->new ({
    FILTERS => {
        # Convert but do not convert % -> %%
        'c' => \&convert_to_c_string,
        # Convert with additionally % -> %%
        'cpc' => \&convert_to_c_string_pc,
    },
});

sub new
{
    my ($package, $options) = @_;
    my $o = {};
    $o->{include_path} = ['.', $FindBin::Bin, $options->{include_path}];
    my $tt = Template->new (
        ABSOLUTE => 1,
        INCLUDE_PATH => $o->{include_path},
#        STRICT => 1,
        ENCODING => 'utf8',
        LOAD_FILTERS => $filters,
    );
    $o->{tt} = $tt;
    bless $o;
    return $o;
}

sub process
{
    my ($o, $in, $vars_ref, $out) = @_;
    my $input = $in;
    my $text;
    if (! ref $in) {
        if (! -f $in) {
            for my $dir (@{$o->{include_path}}) {
                my $in_dir = "$dir/$in";
                if (-f $in_dir) {
                    $in = $in_dir;
                    goto found;
                }
            }
            croak "Input file $in not found";
        }
        found:
        $text = add_lines ($in);
        $input = \$text;
    }
#    print "$input $text $out @{$vars_ref->{fixed_texts}}\n";
    $o->{tt}->process ($input, $vars_ref, $out, {binmode => 'utf8'})
        or die ''. $o->{tt}->error ();
}

1;

__END__

=head1 NAME

C::Template - Template toolkit for C.

=head1 SYNOPSIS

    my $ct = C::Template->new ();
    $ct->process ("x.c.tmpl", \%vars, "x.c");

=head1 DESCRIPTION

This module is a wrapper around L<Template> which adds two filters,
C<c> and C<cpc>.

=head1 METHODS

=head2 new

    my $ct = C::Template->new ();

Create a new object. This incorporates a L<Template> object. To change
the include path,

    my $ct = C::Template->new ({include_path => '/path/to/include/files'});

=head2 process

    $ct->process ('input-template', \%vars, 'output');

This processes C<input-template> into C<output>. C<output> is normally
a C file.

=head1 FILTERS

=head2 c

The C<c> filter changes its input into a C string. Percentage signs
'%' are not changed.

=head2 cpc

The C<cpc> filter changes its input into a C string. Percentage signs
are changed from '%' to '%%' so that the string can be used as the
format argument for printf-style functions without interpolation of
arguments.

=head1 BUGS

=head1 AUTHOR

Ben Bullock, <bkb@cpan.org>

=head1 COPYRIGHT AND LICENCE

Same as Perl.


