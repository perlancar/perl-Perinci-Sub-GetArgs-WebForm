package Perinci::Sub::GetArgs::WebForm;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_args_from_webform);

our %SPEC;

$SPEC{get_args_from_webform} = {
    v => 1.1,
    summary => 'Get subroutine arguments (%args) from web form',
    args => {
        form => {
            schema => 'hash*',
            req => 1,
            pos => 0,
            description => <<'_',

Either from `Plack::Request`'s `query_parameters()` or `CGI`'s `params()`.

_
        },
        meta => {
            schema => ['hash*' => {}],
            description => <<'_',

Actually not required and not currently used.

_
        },
        meta_is_normalized => {
            summary => 'Can be set to 1 if your metadata is normalized, '.
                'to avoid duplicate effort',
            schema => 'bool',
            default => 0,
        },
    },
    # for performance
    args_as => 'array',
    result_naked => 1,
};
sub get_args_from_webform {
    my $form = shift;

    my $args = {};
    for (keys %$form) {
        if (m!/!) {
            my @p = split m!/!, $_;
            next if @p > 10; # hardcode limit
            my $a0 = $args;
            for my $i (0..@p-2) {
                $a0->{$p[$i]} //= {};
                $a0 = $a0->{$p[$i]};
            }
            $a0->{$p[-1]} = $form->{$_};
        } else {
            $args->{$_} = $form->{$_};
        }
    }
    $args;
}

1;
#ABSTRACT: Get subroutine arguments from web form

=head1 SYNOPSIS

 use Perinci::Sub::GetArgs::WebForm qw(get_args_from_webform);

 my %params = $query->params; # from CGI, or from Plack::Request
 my $args = get_args_from_webform(\%params);


=head1 DESCRIPTION

This module provides get_args_from_webform(). This module is used by, among
others, L<Borang>.


=head1 SEE ALSO

L<Perinci>

=cut
